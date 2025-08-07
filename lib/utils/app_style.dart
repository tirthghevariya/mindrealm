import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyle {
  // Dynamic text style with args & default
  static TextStyle textStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textPrimary,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
    Color? decorationColor,
    double height = 1.2,
  }) {
    return GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        decoration: decoration,
        height: height,
        decorationColor: decorationColor);
  }

  // Dynamic box decoration
  static BoxDecoration boxDecoration({
    Color color = AppColors.primary,
    double radius = 12,
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: border,
    );
  }

  // Dynamic input decoration
  static InputDecoration inputDecoration({
    String hint = '',
    Color borderColor = AppColors.primary,
    double radius = 8,
  }) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: borderColor),
      ),
    );
  }

  // Padding defaults
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets cardPadding = EdgeInsets.all(12);
}
