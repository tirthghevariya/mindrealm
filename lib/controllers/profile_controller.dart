import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/controllers/current_user_controller.dart';
import 'package:mindrealm/models/user_model.dart';
import 'package:mindrealm/routers/app_routes.dart';
import 'package:mindrealm/service/local_notification_service.dart';
import 'package:mindrealm/utils/app_text.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/utils/common_show_date_picker.dart';
import 'package:mindrealm/utils/setting.dart';
import 'package:mindrealm/widgets/common_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindrealm/widgets/common_tost.dart';

class ProfileController extends GetxController {
  CurrentUserController currentUserController =
      Get.find<CurrentUserController>();
  Rx<UserProfileModel?> get userProfile => currentUserController.userProfile;

  final RxMap<String, bool> toggles = <String, bool>{
    AppText.dailyReminder: false,
    AppText.weeklyReminder: false,
    AppText.checkGoals: false,
    AppText.healSession: false,
  }.obs;

  final isEditing = false.obs;
  final nameController = TextEditingController().obs;
  final selectedWeekday = "Monday".obs;
  final List allDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  final weekdayStorage = Rx<Map<String, dynamic>?>(null);

  // List daysSelected = [];
  @override
  void onInit() {
    super.onInit();
    nameController.value.text = userProfile.value?.name ?? '';
    toggles[AppText.dailyReminder] = Storage.dailyRemider != null;
    toggles[AppText.weeklyReminder] = Storage.weeklyRemider != null;
    toggles[AppText.checkGoals] = Storage.goalRemider != null;
    toggles[AppText.healSession] = Storage.healRemider != null;

    weekdayStorage.value = getWeeklyReminderFromStorage();

    selectedWeekday.value = weekdayStorage.value?['weekday'] ?? "Monday";
    // _loadNotificationPreferences();
  }

  // *** UPDATED TOGGLE METHOD WITH PERMISSION HANDLING ***
  Future<void> onToggleChanged(
      BuildContext context, String title, bool value) async {
    try {
      bool success = false;

      switch (title) {
        case AppText.dailyReminder:
          success = await updateDailyReminder(context, value) ?? false;
          break;
        case AppText.weeklyReminder:
          success = await updateWeeklyReminder(context, value) ?? false;
          break;
        case AppText.checkGoals:
          success = await updateGoalSessin(context, value) ?? false;
          break;
        case AppText.healSession:
          success = await updateHealSessin(context, value) ?? false;
          break;
        default:
          return;
      }
      if (success) {
        // Update toggle state only if successful
        toggles[title] = value;

        if (value) {
          showToast("$title Notification scheduled successfully!");
        } else {
          showToast("$title Notification cancelled");
        }
      } else {
        showToast("Failed to schedule notification. Please try again.");
      }
    } catch (e) {
      //  showToast("Failed to schedule notification. Please try again.");
      // Keep toggle in original state if error
      // Get.snackbar(
      //   "❌ Error",
      //   "Failed to schedule notification. Please try again.",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   duration: Duration(seconds: 3),
      // );
      log("Error in onToggleChanged: $e");
    }
  }

  Future<bool?> updateDailyReminder(BuildContext context, bool value) async {
    if (value == false) {
      await NotificationApi.notifications.cancel(1);
      return true;
    }

    // 🔹 Get previously stored time or default to 8:00 AM
    TimeOfDay initialTime = _timeOfDayFromJson(Storage.dailyRemider);

    // 🔹 Show picker with saved/default time
    TimeOfDay? selectedTime = await commonShowTimePicker(
      context,
      selectedTime: initialTime,
    );

    if (selectedTime == null) return false;

    bool isdone = await NotificationApi.checkAndRequestPermissions();
    if (!isdone) {
      showToast("Please allow notification permissions to schedule reminders",
          err: true);
      return null;
    }

    // 🔹 Schedule notification
    await NotificationApi.showDailyScheduleNotification(
      title: "How are you feeling today?",
      body: "Take a moment for your daily reflection.",
      time: [
        selectedTime.hour,
        ((selectedTime.minute) % 60),
        0,
      ],
    );

    // 🔹 Save selected time
    Storage.dailyRemider = jsonEncode({
      "hour": selectedTime.hour,
      "minute": selectedTime.minute,
    });

    return true;
  }

  TimeOfDay _timeOfDayFromJson(String? jsonString) {
    if (jsonString == null) return const TimeOfDay(hour: 8, minute: 0);
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return TimeOfDay(hour: data["hour"], minute: data["minute"]);
  }

  Future<bool?> updateWeeklyReminder(context, bool value) async {
    try {
      if (value == false) {
        await NotificationApi.notifications.cancel(2);
        return true;
      }

      bool isdone = await NotificationApi.checkAndRequestPermissions();
      if (isdone == false) {
        showToast("Please allow notification permissions to schedule reminders",
            err: true);
        return null;
      } else {
        // if (selectedWeekday.isEmpty) {
        //   return false;
        // } else {
        // 🔹 Get previously stored time or default to 8:00 AM
        Map<String, dynamic>? weeklyData = getWeeklyReminderFromStorage();
        TimeOfDay initialTime = TimeOfDay(
            hour: weeklyData?['hour'] ?? 8, minute: weeklyData?['minute'] ?? 0);

        // 🔹 Show picker with saved/default time
        TimeOfDay? selectedTime = await commonShowTimePicker(
          context,
          selectedTime: initialTime,
        );
        // int h = int.parse(DateTime.now().hour.toString().padLeft(2, '0')),
        //     m = int.parse(
        //         ((DateTime.now().minute + 2) % 60).toString().padLeft(2, '0'));
        int h = selectedTime!.hour;
        int m = (selectedTime.minute) % 60;

        await NotificationApi.notifications.cancel(2);
        await NotificationApi.showWeeklyScheduleNotification(
          title: "How was your week?",
          body: "Take a moment to reflect on the past 7 days.",
          time: [h, m, 0],
          weekDays: [getWeekdayDateTime(selectedWeekday.value)],
        );
        // ✅ Save to storage
        Storage.weeklyRemider = jsonEncode({
          "weekday": selectedWeekday.value,
          "hour": h,
          "minute": m,
        });
        return true;
        // }
      }
    } catch (e) {
      log("0-=0-=0=-0=-0=-0-= weekly error ${e}");
      return false;
    }
  }

  Future<bool?> updateHealSessin(context, bool value) async {
    try {
      if (value == false) {
        await NotificationApi.notifications.cancel(3);
        return true;
      }

      bool isdone = await NotificationApi.checkAndRequestPermissions();
      if (isdone == false) {
        showToast("Please allow notification permissions to schedule reminders",
            err: true);
        return null;
      } else {
        Map<String, dynamic>? weeklyData = getHealReminderFromStorage();
        TimeOfDay initialTime = TimeOfDay(
            hour: weeklyData?['hour'] ?? 8, minute: weeklyData?['minute'] ?? 0);

        TimeOfDay? selectedTime = await commonShowTimePicker(
          context,
          selectedTime: initialTime,
        );

        int h = selectedTime!.hour;
        int m = (selectedTime.minute) % 60;

        await NotificationApi.showHealNotification(hour: h, minute: m);
        // ✅ Save to storage
        Storage.healRemider = jsonEncode({
          "hour": h,
          "minute": m,
        });
        return true;
        // }
      }
    } catch (e) {
      log("0-=0-=0=-0=-0=-0-= weekly error ${e}");
      return false;
    }
  }

  Future<bool?> updateGoalSessin(context, bool value) async {
    try {
      if (value == false) {
        await NotificationApi.notifications.cancel(4);
        return true;
      }

      bool isdone = await NotificationApi.checkAndRequestPermissions();
      if (isdone == false) {
        showToast("Please allow notification permissions to schedule reminders",
            err: true);
        return null;
      } else {
        Map<String, dynamic>? weeklyData = getGoalReminderFromStorage();
        TimeOfDay initialTime = TimeOfDay(
            hour: weeklyData?['hour'] ?? 8, minute: weeklyData?['minute'] ?? 0);

        TimeOfDay? selectedTime = await commonShowTimePicker(
          context,
          selectedTime: initialTime,
        );

        int h = selectedTime!.hour;
        int m = (selectedTime.minute) % 60;

        await NotificationApi.showGoalsNotification(hour: h, minute: m);
        // ✅ Save to storage
        Storage.goalRemider = jsonEncode({
          "hour": h,
          "minute": m,
        });
        return true;
        // }
      }
    } catch (e) {
      log("0-=0-=0=-0=-0=-0-= weekly error ${e}");
      return false;
    }
  }

  Map<String, dynamic>? getWeeklyReminderFromStorage() {
    if (Storage.weeklyRemider == null) return null;
    return jsonDecode(Storage.weeklyRemider!);
  }

  Map<String, dynamic>? getHealReminderFromStorage() {
    if (Storage.healRemider == null) return null;
    return jsonDecode(Storage.healRemider!);
  }

  Map<String, dynamic>? getGoalReminderFromStorage() {
    if (Storage.goalRemider == null) return null;
    return jsonDecode(Storage.goalRemider!);
  }

  int getWeekdayDateTime(String weekday) {
    switch (weekday) {
      case 'Sunday':
        return DateTime.sunday;
      case 'Monday':
        return DateTime.monday;
      case 'Tuesday':
        return DateTime.tuesday;
      case 'Wednesday':
        return DateTime.wednesday;
      case 'Thursday':
        return DateTime.thursday;
      case 'Friday':
        return DateTime.friday;
      case 'Saturday':
        return DateTime.saturday;
      default:
        throw Exception('Sunday');
    }
  }

  // *** UPDATED LOGOUT WITH NOTIFICATION CLEANUP ***
  Future<void> logout() async {
    try {
      CommonLoader.showLoader();
      toggles[AppText.dailyReminder] = false;
      toggles[AppText.weeklyReminder] = false;
      toggles[AppText.checkGoals] = false;
      toggles[AppText.healSession] = false;
      await NotificationApi.cancelAllNotifications();
      // Firebase और Google logout
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      CommonLoader.hideLoader();
      // Login screen पर redirect
      Get.offAllNamed(Routes.loginScreen);
    } catch (e) {
      CommonLoader.hideLoader();
      log("Logout error: $e");
    }
  }

  updateProfile() async {
    try {
      CommonLoader.showLoader();
      await usersCollection
          .doc(firebaseUserId())
          .update({"name": nameController.value.text});
      await currentUserController.getUserProfile();
      isEditing.value = false;
      CommonLoader.hideLoader();
    } catch (e) {
      CommonLoader.hideLoader();
      log("profileUpdate error: $e");
    }
  }
}
