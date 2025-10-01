import 'package:flutter/material.dart';
import 'package:mindrealm/utils/app_colors.dart';

commonShowDatePicker(context, {DateTime? selectedDate}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary, // Your primary color
            onPrimary: Colors.white, // Text color on primary color
            surface: Colors.white, // Dialog background color
            onSurface: Colors.black87, // Regular text color
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ), // Rounded corners for dialog
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary, // Button text color
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ), // Rounded corners for picker
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  return picked;
}

Future<TimeOfDay?> commonShowTimePicker(BuildContext context,
    {TimeOfDay? selectedTime}) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: selectedTime ?? TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary, // Clock dial hand color
            onPrimary: Colors.white, // Text on primary
            surface: Colors.white, // Background
            onSurface: Colors.black87, // Normal text color
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            hourMinuteShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: AppColors.primary, width: 1),
            ),
            dayPeriodShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: AppColors.primary, width: 1),
            ),
            dialBackgroundColor: AppColors.lightPrimary,
            dialHandColor: AppColors.primary,
            entryModeIconColor: AppColors.primary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary, // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  return picked ?? selectedTime;
}
