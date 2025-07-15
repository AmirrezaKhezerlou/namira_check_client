import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/v2ray_config_model.dart';
import '../settings_service.dart';
import '../view/dashboard_page.dart';

class PingResult {
  final PingStatus status;
  final int? delayMs;

  PingResult(this.status, [this.delayMs]);
}

class DashboardController extends GetxController {
  final pingResults = <String, PingResult>{}.obs;
  RxInt checkedConfigs = 0.obs;
  RxBool stillChecking = true.obs;
  final RxList<V2RayConfig> configList = <V2RayConfig>[].obs;
  final RxList<V2RayConfig> goodConfigList = <V2RayConfig>[].obs;
  final FlutterV2ray flutterV2ray = FlutterV2ray(onStatusChanged: (status) {});

  @override
  void onInit() {
    super.onInit();
    parseSubscriptionResponse();
    pingAllConfigs();
  }

  Future<void> shareGoodConfigsAsText() async {
    if (goodConfigList.isEmpty) {
      return;
    }
    final text = goodConfigList.map((c) => configToUrl(c)).join('\n');
    final params = ShareParams(
      text: text,
      subject: 'کانفیگ‌های سالم V2Ray',
    );

    final result = await SharePlus.instance.share(params);

  }

  void parseSubscriptionResponse() async {
    var subscriptionResponse = Get.arguments;


    final prefs = PreferencesManager();
    await prefs.init();


    subscriptionResponse ??= prefs.getSubscriptionResponse();


    if (subscriptionResponse == null) return;


    if (Get.arguments != null) {
      await prefs.saveSubscriptionResponse(subscriptionResponse);
    }


    final maxConfigs = prefs.getMaxConfigs();

    try {
      final decoded = String.fromCharCodes(base64Decode(subscriptionResponse));
      final configUrls = decoded.split('\n');
      configList.clear();
      int addedConfigs = 0;

      for (var url in configUrls) {
        if (addedConfigs >= maxConfigs) break;
        if (url.trim().isNotEmpty) {
          try {
            final config = V2RayConfig.fromUrl(url.trim());
            configList.add(config);
            addedConfigs++;
          } catch (e) {
            print('خطا در解析 کانفیگ: $e');
          }
        }
      }
    } catch (e) {
      print('خطا در رمزگشایی اشتراک: $e');
    }
  }


  Future<void> pingAllConfigs() async {
    await flutterV2ray.initializeV2Ray();

    final prefs = PreferencesManager();
    await prefs.init();
    final pingUrl = prefs.getPingUrl();

    const maxConcurrent = 5;
    final iterator = configList.iterator;
    final futures = <Future>[];

    Future<void> worker() async {
      while (iterator.moveNext()) {
        final config = iterator.current;
        await pingConfig(config, pingUrl);
      }
    }

    for (int i = 0; i < maxConcurrent; i++) {
      futures.add(worker());
    }

    await Future.wait(futures);

    sortConfigsByPing();

    stillChecking.value = false;
  }

  Future<void> pingConfig(V2RayConfig config, String pingUrl) async {
    try {
      updatePingStatus(config.id, PingStatus.pinging);
      final parser = FlutterV2ray.parseFromURL(configToUrl(config));
      final delay = await flutterV2ray.getServerDelay(
        config: parser.getFullConfiguration(),
        url: pingUrl,
      );
      checkedConfigs.value++;
      if (delay > 0) {
        updatePingStatus(config.id, PingStatus.success, delay);
        if (!goodConfigList.contains(config)) {
          goodConfigList.add(config);
        }
      } else {
        updatePingStatus(config.id, PingStatus.failed);
      }
    } catch (_) {
      updatePingStatus(config.id, PingStatus.failed);
    }
  }

  void updatePingStatus(String id, PingStatus status, [int? delay]) {
    pingResults[id] = PingResult(status, delay);
    pingResults.refresh();
    configList.refresh();
  }

  void sortConfigsByPing() {
    final sorted = [...configList];
    sorted.sort((a, b) {
      final aDelay = pingResults[a.id]?.delayMs ?? double.maxFinite.toInt();
      final bDelay = pingResults[b.id]?.delayMs ?? double.maxFinite.toInt();
      return aDelay.compareTo(bDelay);
    });
    configList.value = sorted;
  }

  void copyConfigToClipboard(V2RayConfig config) {
    final url = configToUrl(config);
    Clipboard.setData(ClipboardData(text: url));
    Get.snackbar(
      'کپی شد!',
      'لینک کانفیگ "${config.remark}" با موفقیت در کلیپ‌برد قرار گرفت.',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  String configToUrl(V2RayConfig config) {
    return Uri(
      scheme: config.protocol,
      userInfo: config.id,
      host: config.host,
      port: config.port,
      queryParameters: config.params,
      fragment: config.remark,
    ).toString();
  }
}
