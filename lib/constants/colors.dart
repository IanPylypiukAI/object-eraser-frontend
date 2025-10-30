import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryBlue = Color(0xFF42A5F5);
  static const Color eraseRed = Color(0xFFB65A50);
  static const Color clearYellow = Color(0xFFFFD54F);
  static const Color downloadBlue = Color.fromARGB(255, 66, 87, 245);
  
  // Text colors
  static const Color textWhite = Colors.white;
  static const Color textDark = Color.fromARGB(255, 96, 93, 93);
  static const Color textGray = Color.fromARGB(255, 79, 78, 78);
  static const Color textBrown = Color.fromARGB(255, 132, 70, 70);
  
  // Mask colors
  static const Color maskRed = Colors.red;
  static const Color dividerWhite = Colors.white;
  static const Color sliderBackground = Color.fromARGB(230, 255, 255, 255);
  static const Color sliderIcon = Colors.black87;
  
  // Background
  static const Color scaffoldBackground = Colors.white;
}

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textWhite,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );
  
  static const TextStyle buttonText = TextStyle(
    color: AppColors.textWhite,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  
  static const TextStyle buttonTextDark = TextStyle(
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textBrown,
  );
  
  static const TextStyle commonText = TextStyle(
    color: AppColors.textGray,
    fontSize: 16.0,
  );
}