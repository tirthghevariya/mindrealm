// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mindrealm/controllers/current_user_controller.dart';
// import 'package:mindrealm/models/user_model.dart';
// import 'package:mindrealm/routers/app_routes.dart';
// import 'package:mindrealm/utils/app_text.dart';
// import 'package:mindrealm/utils/collection.dart';
// import 'package:mindrealm/widgets/common_loader.dart';

// class ProfileController extends GetxController {
//   CurrentUserController currentUserController =
//       Get.find<CurrentUserController>();
//   Rx<UserProfileModel?> get userProfile => currentUserController.userProfile;

//   final Map<String, bool> toggles = {
//     AppText.dailyReminder: true,
//     AppText.weeklyReminder: true,
//     AppText.checkGoals: true,
//     AppText.healSession: true,
//   };

//   final isEditing = false.obs;
//   // String name = "John Doe";
//   // String email = "johndoe@example.com";
//   // String birthday = "01/01/2000";

//   final nameController = TextEditingController().obs;
//   // final emailController = TextEditingController().obs;
//   // final birthdayController = TextEditingController().obs;

//   final selectedWeekday = "Monday".obs;

//   @override
//   void onInit() {
//     super.onInit();
//     nameController.value.text = userProfile.value?.name ?? '';
//     // emailController.value.text = userProfile.value?.email ?? '';
//     // birthdayController.value.text = userProfile.value?. ?? '';
//   }

//   updateProfile() async {
//     try {
//       // DocumentSnapshot doc =
//       CommonLoader.showLoader();
//       await usersCollection
//           .doc(firebaseUserId())
//           .update({"name": nameController.value.text});
//       await currentUserController.getUserProfile();
//       isEditing.value = false;
//       CommonLoader.hideLoader();
//     } catch (e) {
//       CommonLoader.hideLoader();
//       log("0-=0-=-=0-= error profileUpdate.  ${e}");
//     }
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/controllers/current_user_controller.dart';
import 'package:mindrealm/models/user_model.dart';
import 'package:mindrealm/routers/app_routes.dart';
import 'package:mindrealm/service/notofication_service.dart';
import 'package:mindrealm/utils/app_text.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/common_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  @override
  void onInit() {
    super.onInit();
    nameController.value.text = userProfile.value?.name ?? '';
    _loadNotificationPreferences();
  }

  // Load saved notification preferences
  Future<void> _loadNotificationPreferences() async {
    toggles[AppText.dailyReminder] =
        await NotificationService.getPreference('daily_reminder_enabled');
    toggles[AppText.weeklyReminder] =
        await NotificationService.getPreference('weekly_reminder_enabled');
    toggles[AppText.checkGoals] =
        await NotificationService.getPreference('check_goals_enabled');
    toggles[AppText.healSession] =
        await NotificationService.getPreference('heal_session_enabled');
  }

  // *** UPDATED TOGGLE METHOD WITH PERMISSION HANDLING ***
  Future<void> onToggleChanged(String title, bool value) async {
    try {
      bool success = false;

      switch (title) {
        case AppText.dailyReminder:
          success = await NotificationService.scheduleDailyReminder(value);
          break;
        case AppText.weeklyReminder:
          success = await NotificationService.scheduleWeeklyReminder(
              value, selectedWeekday.value);
          break;
        default:
          return;
        // case AppText.checkGoals:
        //   success = await NotificationService.scheduleCheckGoals(value);
        //   break;
        // case AppText.healSession:
        //   success = await NotificationService.scheduleHealSession(value);
        //   break;
      }

      if (success) {
        // Update toggle state only if successful
        toggles[title] = value;

        if (value) {
          Get.snackbar(
            "✅ Success",
            "Notification scheduled successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            "ℹ️ Info",
            "Notification cancelled",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        }
      } else {
        // Keep toggle in original state if failed
        // Don't change toggles[title] value

        Get.snackbar(
          "❌ Permission Required",
          "Please allow notification permissions to schedule reminders",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () {
              // Try again
              onToggleChanged(title, value);
            },
            child: Text("Try Again", style: TextStyle(color: Colors.white)),
          ),
        );
      }
    } catch (e) {
      // Keep toggle in original state if error
      Get.snackbar(
        "❌ Error",
        "Failed to schedule notification. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      log("Error in onToggleChanged: $e");
    }
  }

  // Handle weekday selection change
  Future<void> onWeekdayChanged(String newDay) async {
    selectedWeekday.value = newDay;
    if (toggles[AppText.weeklyReminder] == true) {
      bool success =
          await NotificationService.scheduleWeeklyReminder(true, newDay);
      if (success) {
        Get.snackbar(
          "✅ Updated",
          "Weekly reminder updated for $newDay",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    }
  }

  // *** UPDATED LOGOUT WITH NOTIFICATION CLEANUP ***
  Future<void> logout() async {
    try {
      CommonLoader.showLoader();

      // Cancel all notifications and clear preferences
      await NotificationService.cancelAllNotificationsOnLogout();

      // Reset local toggles
      toggles[AppText.dailyReminder] = false;
      toggles[AppText.weeklyReminder] = false;
      toggles[AppText.checkGoals] = false;
      toggles[AppText.healSession] = false;

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
