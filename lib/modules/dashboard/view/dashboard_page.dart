import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:namira_tester/modules/dashboard/controller/dashboard_controller.dart';
import 'package:namira_tester/modules/dashboard/widget/animated_timer_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/theme_colores.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:share_plus/share_plus.dart';

import '../settings_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isDarkMode = Get.isDarkMode;
  final Color bg = Get.isDarkMode
      ? ThemeColors.scaffoldDarkBackgroundColor
      : ThemeColors.scaffoldLightBackgroundColor;

  DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5),
                buildCustomAppbar(context),
                const SizedBox(height: 30),
                buildTitleSection(),
                SizedBox(height: 20),
                buildStatusWidget(dashboardController),
                SizedBox(height: 20),
                buildConfigsView(dashboardController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildTitleSection() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'نامیرا چک',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazir',
              color: ThemeColors.getTextColor(),
            ),
          ),
        ],
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'بررسی کانفیگ های متصل',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: ThemeColors.getTextColor(),
            ),
          ),
        ],
      ),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Uri uri = Uri.parse('https://t.me/NamiraNet');
              launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: Icon(LineIcons.telegram),
          ),
          SizedBox(width: 8.0),
          InkWell(
            onTap: () {
              Uri uri = Uri.parse('https://github.com/NaMiraNet');
              launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: Icon(LineIcons.github),
          ),
          SizedBox(width: 8.0),
          InkWell(
            onTap: () {
              Uri uri = Uri.parse('https://namira.dev');
              launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            child: Icon(LineIcons.internetExplorer),
          ),
        ],
      ),
    ],
  );
}

enum PingStatus { idle, pinging, success, failed }

Widget buildCustomAppbar(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          GestureDetector(
            onTap: () {
              ConfigSettingsBottomSheet.show(context);
            },
            child: Icon(LineIcons.cog, size: 30),
          ),
        ],
      ),
      Row(
        children: [
          GestureDetector(
            onTap: () {
              launchUrl(
                Uri.parse('https://www.coffeebede.com/amirreza5040'),
              );
            },
            child: Image.asset('assets/cofee.png',width: 30,height: 30,),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('https://t.me/AmirrezaKhezerlou'));
            },
            child: Icon(
              LineIcons.telegramPlane,
              color: Colors.purple,
              size: 30,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget buildStatusWidget(DashboardController controller) {
  return Container(
    padding: EdgeInsets.all(8.0),
    width: Get.width,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/namira.png'),
        opacity: 0.2,
      ),
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تازه بروز شده',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 2),
            Icon(LineIcons.cloud, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'وضعیت:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() => Text(controller.configList.length.toString())),
            SizedBox(width: 8),
            Text(
              'تعداد کانفیگ های دریافت شده:',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() => Text(controller.checkedConfigs.value.toString())),
            SizedBox(width: 4),
            Obx(
              () => Visibility(
                visible: controller.stillChecking.value,
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Get.isDarkMode
                        ? ThemeColors.textDarkColor
                        : ThemeColors.textLightColor,
                    strokeWidth: 1,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'تعداد کانفیگ های بررسی شده:',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() => Text(controller.goodConfigList.length.toString())),
            SizedBox(width: 8),
            Text(
              'تعداد کانفیگ های متصل:',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                controller.shareGoodConfigsAsText();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'انتقال کانفیگ های متصل به کلاینت',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(LineIcons.share, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildConfigsView(DashboardController controller) {
  final RxBool showAllConfigs = RxBool(false);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              LineIcons.syncIcon,
              color: Get.isDarkMode ? Colors.white70 : Colors.black87,
            ),
            tooltip: 'دریافت مجدد پینگ',
            onPressed:(){
              controller.stillChecking.value = true;
              controller.pingResults.clear();
              controller.checkedConfigs.value = 0;
              controller.goodConfigList.clear();
              controller.pingAllConfigs();
            }
          ),
          Text(
            'کانفیگ‌های متصل:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazir',
              color: Get.isDarkMode ? Colors.white : Colors.black87,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => Checkbox(
              value: showAllConfigs.value,
              onChanged: (value) => showAllConfigs.value = value ?? false,
              activeColor: Get.isDarkMode ? Colors.white70 : Colors.black87,
              checkColor: Get.isDarkMode ? Colors.black87 : Colors.white,
            ),
          ),
          Text(
            'نمایش همه کانفیگ‌ها',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Vazir',
              color: Get.isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
      const SizedBox(height: 8),
      Obx(
        () => showAllConfigs.value
            ? buildConfigsListView(controller)
            : buildConfigsGridView(controller),
      ),
    ],
  );
}

Widget buildConfigsListView(DashboardController controller) {
  return Obx(
    () => ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.configList.length,
      itemBuilder: (context, index) {
        final config = controller.configList[index];
        final result =
            controller.pingResults[config.id] ?? PingResult(PingStatus.idle);

        Color getStatusColor(PingStatus status) {
          switch (status) {
            case PingStatus.pinging:
              return Colors.orange;
            case PingStatus.success:
              return Colors.green;
            case PingStatus.failed:
              return Colors.red;
            default:
              return Get.isDarkMode
                  ? Colors.grey.shade600
                  : Colors.grey.shade400;
          }
        }

        String getPingText(PingResult result) {
          switch (result.status) {
            case PingStatus.pinging:
              return '...';
            case PingStatus.success:
              return '${result.delayMs}ms';
            case PingStatus.failed:
              return 'خطا';
            default:
              return '-';
          }
        }

        return InkWell(
          onTap: () => controller.copyConfigToClipboard(config),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Get.isDarkMode ? Colors.black87 : Colors.white,
                border: Border.all(
                  color: Get.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getStatusColor(result.status),
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        getPingText(result),
                        style: TextStyle(
                          fontSize: 9,
                          color: Get.isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.remark,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Get.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${config.protocol.toUpperCase()} • ${config.host}:${config.port}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Get.isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Colors.grey.shade900
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Get.isDarkMode
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      config.protocol.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget buildConfigsGridView(DashboardController controller) {
  return Obx(
    () => GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: controller.goodConfigList.length,
      // Changed to goodConfigList
      itemBuilder: (context, index) {
        final config = controller.goodConfigList[index];
        final result =
            controller.pingResults[config.id] ?? PingResult(PingStatus.idle);

        Color getStatusColor(PingStatus status) {
          switch (status) {
            case PingStatus.pinging:
              return Colors.orange;
            case PingStatus.success:
              return Colors.green;
            case PingStatus.failed:
              return Colors.red;
            default:
              return Get.isDarkMode
                  ? Colors.grey.shade600
                  : Colors.grey.shade400;
          }
        }

        String getPingText(PingResult result) {
          switch (result.status) {
            case PingStatus.pinging:
              return '...';
            case PingStatus.success:
              return '${result.delayMs}ms';
            case PingStatus.failed:
              return 'خطا';
            default:
              return '-';
          }
        }

        return InkWell(
          onTap: () => controller.copyConfigToClipboard(config),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.black87 : Colors.white,
              border: Border.all(
                color: Get.isDarkMode
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black87,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getStatusColor(result.status),
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.white.withOpacity(0.3)
                          : Colors.black.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  getPingText(result),
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.grey.shade900
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    config.protocol.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Get.isDarkMode
                          ? Colors.white.withOpacity(0.9)
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget buildBottomSheet(
  BuildContext context,
  DashboardController controller,
  dynamic config,
  PingResult result,
) {
  String getPingText(PingResult result) {
    switch (result.status) {
      case PingStatus.pinging:
        return '...';
      case PingStatus.success:
        return '${result.delayMs}ms';
      case PingStatus.failed:
        return 'خطا';
      default:
        return '-';
    }
  }

  String generateV2rayNgLink(dynamic config) {
    return 'v2rayng://install-config?url=${config.protocol}://${config.id}@${config.host}:${config.port}?security=none&encryption=none&host=${config.host}&headerType=http&type=tcp#${Uri.encodeComponent(config.remark)}';
  }

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Get.isDarkMode ? Colors.black87 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Get.isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black87,
        width: 1,
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                config.remark,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: result.status == PingStatus.success
                    ? Colors.green
                    : result.status == PingStatus.failed
                    ? Colors.red
                    : result.status == PingStatus.pinging
                    ? Colors.orange
                    : Get.isDarkMode
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${config.protocol.toUpperCase()} • ${config.host}:${config.port}',
          style: TextStyle(
            fontSize: 14,
            color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 16),
        Text(
          'پینگ: ${getPingText(result)}',
          style: TextStyle(
            fontSize: 14,
            color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => controller.copyConfigToClipboard(config),
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('کپی کانفیگ', style: TextStyle(fontFamily: 'Vazir')),
            ),
            ElevatedButton(
              onPressed: () => Share.share(generateV2rayNgLink(config)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'اشتراک ‌گذاری',
                style: TextStyle(fontFamily: 'Vazir'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}





