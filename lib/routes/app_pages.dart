import 'package:get/get.dart';
import 'package:namira_tester/modules/dashboard/binding.dart';
import 'package:namira_tester/modules/dashboard/view/dashboard_page.dart';
import 'package:namira_tester/modules/splash_screen/binding.dart';
import 'package:namira_tester/modules/splash_screen/view/splash_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreenPage(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),

  ];
}
