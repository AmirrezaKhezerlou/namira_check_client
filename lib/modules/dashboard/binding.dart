
import 'package:get/get.dart';
import 'package:namira_tester/modules/dashboard/controller/dashboard_controller.dart';
import 'package:namira_tester/modules/splash_screen/controller/splash_controller.dart';


class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(()=>DashboardController());
  }


}
