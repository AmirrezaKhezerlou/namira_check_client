import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/url_links.dart';
import '../../../routes/app_routes.dart';
import '../../dashboard/settings_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<String?> fetchConfigs() async {
    try {
      final response = await _dio.get(UrlLinks.subscriptionUrl);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load configs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching configs: $e');
      final prefs = PreferencesManager();
      await prefs.init();
      final storedResponse = prefs.getSubscriptionResponse();
      if (storedResponse != null) {
        Get.snackbar(
          'استفاده از تاریخچه',
          'دریافت کانفیگ‌های جدید ناموفق بود. از کانفیگ‌های ذخیره‌شده استفاده می‌شود.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          colorText: Get.isDarkMode ? Colors.white : Colors.black87,
        );
      }
      return storedResponse;
    }
  }

  void navigateToDashboard() async {
    final result = await fetchConfigs();
    Get.offNamed(Routes.DASHBOARD, arguments: result);
  }


  Future<bool> checkAndRequestNotificationPermission() async {

    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {

      return true;
    } else if (status.isDenied || status.isPermanentlyDenied) {

      PermissionStatus newStatus = await Permission.notification.request();

      if (newStatus.isGranted) {
        return true;
      } else {

        return false;
      }
    }
    return false;
  }

  @override
  void onInit() {
    checkAndRequestNotificationPermission();
    navigateToDashboard();
    super.onInit();
  }
}