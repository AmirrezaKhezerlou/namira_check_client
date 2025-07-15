
import 'package:get/get.dart';
import 'package:namira_tester/modules/splash_screen/controller/splash_controller.dart';


class SplashScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(()=>SplashController());
  }


}
