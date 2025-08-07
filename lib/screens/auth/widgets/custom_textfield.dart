import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_style.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final TextStyle? hintStyle;
  final bool showToggle;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.hintStyle,
    this.showToggle = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (mounted) {
          setState(() {
            _isFocused = hasFocus;
          });
        }
      },
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        autofillHints: widget.autofillHints,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        style: AppStyle.textStyle(),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: widget.hintStyle ??
              AppStyle.textStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
              ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.primary.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.showToggle || widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: _isFocused ? AppColors.primary : AppColors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    }
                  },
                )
              : null,
          errorStyle: AppStyle.textStyle(
            fontSize: 12,
            color: AppColors.error,
          ),
          counterStyle: AppStyle.textStyle(
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}
