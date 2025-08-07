import 'package:flutter/material.dart';

import 'package:get/get.dart';


class SizeConfig {
  static MediaQueryData get _mediaQuery => MediaQuery.of(Get.context!);

  static double get screenWidth => _mediaQuery.size.width;
  static double get screenHeight => _mediaQuery.size.height;

  /// Returns scaled width based on 375 base width
  static double getWidth(double value) => (screenWidth / 375.0) *value;

  /// Returns scaled height based on 812 base height
  static double getHeight(double value) => (screenHeight / 812.0) * value;

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

