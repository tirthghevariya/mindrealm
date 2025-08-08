import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeConfig {
  // static MediaQueryData get _mediaQuery => MediaQuery.of(Get.context!);

  static double screenWidth = Get.width;
  static double screenHeight = Get.height;

  /// Returns scaled width based on 375 base width
  static double getWidth(double value) => (Get.width / 375.0) * value;

  /// Returns scaled height based on 812 base height
  static double getHeight(double value) => (Get.height / 812.0) * value;

  /// Automatically returns scaled Size based on optional width & height
  static Size getSize({double? width, double? height}) {
    return Size(
      width != null ? getWidth(width) : 0,
      height != null ? getHeight(height) : 0,
    );
  }

  /// Returns both height and width individually
  static Map<String, double> auto({
    double? width,
    double? height,
  }) {
    return {
      "width": width != null ? getWidth(width) : 0,
      "height": height != null ? getHeight(height) : 0,
    };
  }
}
