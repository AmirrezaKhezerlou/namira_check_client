import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:namira_tester/core/constants/theme_colores.dart';
import 'package:namira_tester/modules/splash_screen/controller/splash_controller.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  SplashController splashController = Get.find();
  bool isDarkMode = Get.isDarkMode;
  final Color bg = Get.isDarkMode
      ? ThemeColors.scaffoldDarkBackgroundColor
      : ThemeColors.scaffoldLightBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: bg),
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/namira.png',
                width: width / 2,
                height: width / 2,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Namira Tester V 0.0.1',
              style: TextStyle(
                color: isDarkMode
                    ? ThemeColors.textDarkColor
                    : ThemeColors.textLightColor,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: isDarkMode
                    ? ThemeColors.textDarkColor
                    : ThemeColors.textLightColor,
                strokeWidth: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
