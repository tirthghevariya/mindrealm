import 'package:flutter/material.dart';
import 'package:mindrealm/utils/app_colors.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double? borderRadius;
  final Widget? icon;
  final double? height;
  final double? fontSize;
  final bool outline;
  final bool isExpand;
  final bool isboxShodow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final List<BoxShadow>? boxShadow;
  const CommonButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.icon,
    this.height,
    this.fontSize,
    this.padding,
    this.outline = false,
    this.isExpand = true,
    this.isboxShodow = true,
    this.margin,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: margin,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          color: backgroundColor ?? AppColors.primary,
          border: outline
              ? Border.all(color: borderColor ?? AppColors.primary)
              : null,
          boxShadow: isboxShodow
              ? [
                  BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      offset: const Offset(5, 10),
                      blurRadius: 40,
                      spreadRadius: 0)
                ]
              : boxShadow,
        ),
        child: Row(
          mainAxisSize: isExpand == true ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon ?? const SizedBox(),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: (textColor ?? AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
