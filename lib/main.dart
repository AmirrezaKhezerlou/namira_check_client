import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namira_tester/modules/splash_screen/binding.dart';
import 'package:namira_tester/routes/app_pages.dart';
import 'package:namira_tester/routes/app_routes.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'core/constants/url_links.dart';
import 'modules/dashboard/settings_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'config_update_channel',
    'Config Updates',
    description: 'نوتیفیکیشن برای به‌روزرسانی کانفیگ‌ها',
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

Future<bool> checkAndRequestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied || status.isPermanentlyDenied) {
    PermissionStatus newStatus = await Permission.notification.request();
    if (newStatus.isGranted) {
      return true;
    }
  }
  return false;
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await initializeNotifications();
      final prefs = PreferencesManager();
      await prefs.init();
      String urlToFetch = prefs.getIranSubscriptionUrl();
      if (urlToFetch.isEmpty) {
        urlToFetch = UrlLinks.iranSubscriptionUrl;
      }
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(urlToFetch));
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();

        await prefs.saveSubscriptionResponse(responseBody);
        final now = DateTime.now().toIso8601String();
        await prefs.saveLastSuccessfulFetchTime(now);

        await flutterLocalNotificationsPlugin.show(
          0,
          'به‌روزرسانی کانفیگ',
          'کانفیگ‌ها با موفقیت دریافت شدند.',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'config_update_channel',
              'Config Updates',
              importance: Importance.low,
              priority: Priority.low,
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );

      }
    } catch (e) {
      print("Error in background task: $e");
    }
    return Future.value(true);
  });
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeNotifications();

  await checkAndRequestNotificationPermission();

  final prefs = PreferencesManager();
  await prefs.init();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);


  await Workmanager().registerPeriodicTask(
    "1",
    "updateConfigsTask",
    frequency: Duration(hours: 4),
    existingWorkPolicy: ExistingWorkPolicy.replace,
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresDeviceIdle: true,
    ),
  );

  Workmanager().registerOneOffTask("2", "updateConfigsTask");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Namira-Check',
      getPages: AppPages.routes,
      theme: ThemeData(fontFamily: 'Sahel'),
      initialRoute: Routes.SPLASH,
      initialBinding: SplashScreenBinding(),
    );
  }
}
