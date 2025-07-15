import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/url_links.dart';

// Singleton class for SharedPreferences
class PreferencesManager {
  static final PreferencesManager _instance = PreferencesManager._internal();

  factory PreferencesManager() => _instance;

  PreferencesManager._internal();

  static const String _keySubscriptionUrl = 'subscription_url';
  static const String _keyIranSubscriptionUrl = 'iran_subscription_url';
  static const String _keyMaxConfigs = 'max_configs';
  static const String _keyPingUrl = 'ping_url';
  static const String _keySubscriptionResponse = 'subscription_response';
  static const String _keyLastSuccessfulFetchTime =
      'last_successful_fetch_time';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ذخیره و گرفتن SubscriptionUrl
  Future<void> saveSubscriptionUrl(String url) async {
    await _prefs.setString(_keySubscriptionUrl, url);
  }

  String getSubscriptionUrl() {
    return _prefs.getString(_keySubscriptionUrl) ?? UrlLinks.subscriptionUrl;
  }

  // ذخیره و گرفتن IranSubscriptionUrl
  Future<void> saveIranSubscriptionUrl(String url) async {
    await _prefs.setString(_keyIranSubscriptionUrl, url);
  }

  String getIranSubscriptionUrl() {
    return _prefs.getString(_keyIranSubscriptionUrl) ??
        UrlLinks.iranSubscriptionUrl;
  }

  // Max configs
  Future<void> saveMaxConfigs(int maxConfigs) async {
    await _prefs.setInt(_keyMaxConfigs, maxConfigs);
  }

  int getMaxConfigs() {
    return _prefs.getInt(_keyMaxConfigs) ?? 50;
  }

  // Ping URL
  Future<void> savePingUrl(String url) async {
    await _prefs.setString(_keyPingUrl, url);
  }

  String getPingUrl() {
    return _prefs.getString(_keyPingUrl) ?? 'https://www.instagram.com';
  }

  // Subscription response
  Future<void> saveSubscriptionResponse(String response) async {
    await _prefs.setString(_keySubscriptionResponse, response);
  }

  String? getSubscriptionResponse() {
    return _prefs.getString(_keySubscriptionResponse);
  }

  // ✅ Last successful fetch time
  Future<void> saveLastSuccessfulFetchTime(String timestamp) async {
    await _prefs.setString(_keyLastSuccessfulFetchTime, timestamp);
  }

  String? getLastSuccessfulFetchTime() {
    return _prefs.getString(_keyLastSuccessfulFetchTime);
  }
}

// Bottom sheet widget
class ConfigSettingsBottomSheet {
  static String _formatDateTime(String iso) {
    try {
      final dateTime = DateTime.parse(iso).toLocal();
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
          'ساعت ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'نامشخص';
    }
  }

  static Future<void> show(BuildContext context) async {
    // Initialize PreferencesManager
    final prefs = PreferencesManager();
    await prefs.init();

    final lastFetch = prefs.getLastSuccessfulFetchTime();
    final RxString lastFetchTime = RxString(
      lastFetch != null
          ? _formatDateTime(lastFetch)
          : 'تا حالا بروزرسانی نشده 😢',
    );
    // State management for UI
    final RxInt maxConfigs = RxInt(prefs.getMaxConfigs());
    final RxString selectedUrl = RxString(prefs.getPingUrl());

    // List of popular ping URLs
    final pingUrls = [
      'https://www.instagram.com',
      'https://www.telegram.org',
      'https://www.youtube.com',
      'https://www.google.com',
      'https://www.twitter.com',
      'https://www.facebook.com',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        builder: (context, scrollController) {
          final TextEditingController subscriptionController =
              TextEditingController(text: prefs.getSubscriptionUrl());
          final TextEditingController iranSubscriptionController =
              TextEditingController(text: prefs.getIranSubscriptionUrl());
          return Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.black87 : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تنظیمات کانفیگ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Vazir',
                            color: Get.isDarkMode
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            LineIcons.times,
                            color: Get.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Max Configs Slider
                    Obx(
                      () => Text(
                        'حداکثر تعداد کانفیگ‌ها: ${maxConfigs.value}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Vazir',
                          color: Get.isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                    ),
                    Obx(
                      () => Slider(
                        value: maxConfigs.value.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 100,
                        activeColor: Get.isDarkMode
                            ? Colors.white70
                            : Colors.black87,
                        inactiveColor: Get.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        onChanged: (value) {
                          maxConfigs.value = value
                              .toInt(); // Update text in real-time
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ping URL Dropdown
                    Text(
                      'آدرس پینگ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Vazir',
                        color: Get.isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                          ),
                          color: Get.isDarkMode
                              ? Colors.grey.shade900
                              : Colors.grey.shade100,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedUrl.value,
                            isExpanded: true,
                            icon: Icon(
                              LineIcons.angleDown,
                              color: Get.isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                            dropdownColor: Get.isDarkMode
                                ? Colors.grey.shade900
                                : Colors.white,
                            items: pingUrls.map((url) {
                              return DropdownMenuItem<String>(
                                value: url,
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Icon(
                                      _getIconForUrl(url),
                                      color: Get.isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _getDisplayNameForUrl(url),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Vazir',
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                selectedUrl.value = value;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(LineIcons.clock, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(
                            () => Text(
                              'آخرین بروزرسانی موفق کانفیگ‌ها: ${lastFetchTime.value}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Vazir',
                                color: Colors.grey,
                              ),
                              textDirection: TextDirection.rtl,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // بعد از بخش Ping URL و قبل از دکمه ذخیره
                    const SizedBox(height: 16),
                    Text(
                      'لینک اشتراک (Subscription URL)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Vazir',
                        color: Get.isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: subscriptionController,
                            decoration: InputDecoration(
                              hintText:
                                  'لینک اشتراک را وارد کنید یا خالی بگذارید',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.redAccent),
                          tooltip: 'پاک کردن لینک',
                          onPressed: () {
                            subscriptionController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'لینک اشتراک ایران (Iran Subscription URL)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Vazir',
                        color: Get.isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: iranSubscriptionController,
                            decoration: InputDecoration(
                              hintText:
                                  'لینک اشتراک ایران را وارد کنید یا خالی بگذارید',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.redAccent),
                          tooltip: 'پاک کردن لینک',
                          onPressed: () {
                            iranSubscriptionController.clear();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'اگر خالی بگذارید، لینک‌های پیش‌فرض استفاده می‌شوند.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        await prefs.saveMaxConfigs(maxConfigs.value);
                        await prefs.savePingUrl(selectedUrl.value);

                        // ذخیره لینک‌ها
                        String subUrl = subscriptionController.text.trim();
                        String iranSubUrl = iranSubscriptionController.text
                            .trim();

                        if (subUrl.isEmpty) {
                          // اگر خالی بود، حذف یا مقدار پیش‌فرض ذخیره بشه (یا می‌تونی اینجا کاری نکنی چون get تابع default میده)
                          // مثلا می‌تونی کلید را پاک کنی یا مقدار پیش‌فرض بزاری
                          await prefs.saveSubscriptionUrl(
                            UrlLinks.subscriptionUrl,
                          );
                        } else {
                          await prefs.saveSubscriptionUrl(subUrl);
                        }

                        if (iranSubUrl.isEmpty) {
                          await prefs.saveIranSubscriptionUrl(
                            UrlLinks.iranSubscriptionUrl,
                          );
                        } else {
                          await prefs.saveIranSubscriptionUrl(iranSubUrl);
                        }

                        Navigator.pop(context);
                      },

                      icon: Icon(
                        LineIcons.save,
                        color: Get.isDarkMode ? Colors.black87 : Colors.white,
                      ),
                      label: Text(
                        'ذخیره',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          color: Get.isDarkMode ? Colors.black87 : Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                        foregroundColor: Get.isDarkMode
                            ? Colors.black87
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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

  // Helper method to get display name for URL
  static String _getDisplayNameForUrl(String url) {
    switch (url) {
      case 'https://www.instagram.com':
        return 'اینستاگرام';
      case 'https://www.telegram.org':
        return 'تلگرام';
      case 'https://www.youtube.com':
        return 'یوتیوب';
      case 'https://www.google.com':
        return 'گوگل';
      case 'https://www.twitter.com':
        return 'توییتر';
      case 'https://www.facebook.com':
        return 'فیسبوک';
      default:
        return url;
    }
  }

  // Helper method to get icon for URL
  static IconData _getIconForUrl(String url) {
    switch (url) {
      case 'https://www.instagram.com':
        return LineIcons.instagram;
      case 'https://www.telegram.org':
        return LineIcons.telegram;
      case 'https://www.youtube.com':
        return LineIcons.youtube;
      case 'https://www.google.com':
        return LineIcons.googleLogo;
      case 'https://www.twitter.com':
        return LineIcons.twitter;
      case 'https://www.facebook.com':
        return LineIcons.facebook;
      default:
        return LineIcons.globe;
    }
  }
}
