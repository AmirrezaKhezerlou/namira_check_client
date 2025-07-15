import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeColors{
  static Color scaffoldLightBackgroundColor = Color(0xffF5F5F5);
  static Color scaffoldDarkBackgroundColor = Color(0xff1D1616);

  static Color textLightColor = Color(0xff1B3C53);
  static Color textDarkColor = Colors.white;

  static Color iconLightColor = Color(0xff090040);
  static Color iconDarkColor = Colors.white;


  static Color getTextColor(){
    bool isDark = Get.isDarkMode;
    if(isDark){
      return textDarkColor;
    }else{
      return textLightColor;
    }
  }


}