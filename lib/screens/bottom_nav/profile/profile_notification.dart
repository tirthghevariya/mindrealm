// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mindrealm/controllers/profile_controller.dart';
// import 'package:mindrealm/routers/app_routes.dart';

// import '../../../utils/app_assets.dart';
// import '../../../utils/app_colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/profile_controller.dart';
import 'package:mindrealm/routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';

class ProfileNotificationsScreen extends GetView<ProfileController> {
  const ProfileNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(AppImages.profilebg),
            fit: BoxFit.fill,
          )),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header and Profile Section (unchanged)
                Padding(
                  padding: EdgeInsets.only(
                    top: statusBarSize + Get.width * 0.02,
                    left: 8,
                    right: 8,
                  ),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back,
                        color: AppColors.brown, size: 32),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      Text(
                        AppText.profile,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: SizeConfig.getWidth(24),
                          fontWeight: FontWeight.w500,
                          color: AppColors.brown,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: SizeConfig.getHeight(16)),
                      _editableField(
                          AppText.name, controller.nameController.value),
                      SizedBox(height: SizeConfig.getHeight(18)),

                      // Email Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              AppText.email,
                              style: GoogleFonts.openSans(
                                fontSize: SizeConfig.getWidth(15),
                                fontWeight: FontWeight.w700,
                                color: AppColors.brown,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              controller.userProfile.value?.email ?? '',
                              style: GoogleFonts.openSans(
                                fontSize: SizeConfig.getWidth(14),
                                color: AppColors.brown,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: SizeConfig.getHeight(18)),

                      // Edit Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.isEditing.value =
                                  !controller.isEditing.value;
                              controller.nameController.value.text =
                                  controller.userProfile.value?.name ?? '';
                            },
                            child: Text(
                              controller.isEditing.value
                                  ? AppText.cancel
                                  : AppText.editInfo,
                              style: GoogleFonts.openSans(
                                fontSize: SizeConfig.getWidth(14),
                                color: AppColors.brown,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (controller.isEditing.value) ...[
                            InkWell(
                              onTap: () async =>
                                  await controller.updateProfile(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.brown,
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.openSans(
                                    fontSize: SizeConfig.getWidth(12),
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: SizeConfig.getHeight(24)),
                      Text(
                        AppText.changePassword,
                        style: GoogleFonts.openSans(
                          fontSize: SizeConfig.getWidth(14),
                          color: AppColors.brown,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: SizeConfig.getHeight(60)),

                      // Notifications Section
                      Text(
                        AppText.notifications,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: SizeConfig.getWidth(22),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: AppColors.brown,
                        ),
                      ),
                      SizedBox(height: SizeConfig.getHeight(26)),

                      // Updated Toggle Tiles with Notification Logic
                      _toggleTile(context, AppText.dailyReminder),
                      _toggleTile(context, AppText.weeklyReminder),
                      _toggleTile(context, AppText.checkGoals),
                      _toggleTile(context, AppText.healSession),

                      SizedBox(height: SizeConfig.getHeight(20)),

                      // Weekday Selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: SizeConfig.getWidth(230),
                            child: Text(
                              AppText.chooseDay,
                              style: GoogleFonts.openSans(
                                fontSize: SizeConfig.getWidth(14),
                                color: AppColors.brown,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _showWeekdayPicker,
                            child: Text(
                              controller.selectedWeekday.value,
                              style: GoogleFonts.openSans(
                                fontSize: SizeConfig.getWidth(14),
                                color: AppColors.brown,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: SizeConfig.getHeight(32)),

                      // Logout Button
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.brown,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.getWidth(100),
                                    vertical: SizeConfig.getHeight(12),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.getWidth(8)),
                                  ),
                                ),
                                onPressed: () async {
                                  await controller.logout();
                                },
                                child: Text(
                                  AppText.logout,
                                  style: GoogleFonts.openSans(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.getWidth(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.brown,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.getWidth(72),
                                    vertical: SizeConfig.getHeight(12),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.getWidth(8)),
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    final user =
                                        FirebaseAuth.instance.currentUser;

                                    if (user != null) {
                                      // Try deleting the account
                                      await user.delete();

                                      // Optionally sign out after delete
                                      await FirebaseAuth.instance.signOut();

                                      // Navigate or show success message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Account deleted successfully")),
                                      );
                                      await controller.logout();
                                      // Example: Navigate back to login screen
                                      // Navigator.pushReplacementNamed(context, '/login');
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'requires-recent-login') {
                                      // Re-authenticate the user before deleting
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Please log in again to delete your account."),
                                        ),
                                      );
                                      // You can redirect user to login screen for re-authentication
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Error: ${e.message}")),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  "Delete Account",
                                  style: GoogleFonts.openSans(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.getWidth(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _editableField(String label, TextEditingController dataController) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: SizeConfig.getWidth(15),
                fontWeight: FontWeight.w700,
                color: AppColors.brown,
              ),
            ),
          ),
          SizedBox(width: 10),
          controller.isEditing.value
              ? Expanded(
                  child: TextField(
                    controller: dataController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              : Expanded(
                  child: Text(
                    dataController.text,
                    style: GoogleFonts.openSans(
                      fontSize: SizeConfig.getWidth(14),
                      color: AppColors.brown,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Updated Toggle Tile with Notification Logic
  Widget _toggleTile(context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.getHeight(12)),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.openSans(
                    fontSize: SizeConfig.getWidth(15),
                    color: AppColors.brown,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Switch(
                value: controller.toggles[title] ?? false,
                activeColor: AppColors.brown,
                inactiveThumbColor: AppColors.brown.withValues(alpha: 0.5),
                onChanged: (value) async {
                  await controller.onToggleChanged(context, title, value);
                },
              ),
            ],
          )),
    );
  }

  void _showWeekdayPicker() {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Clear Selection',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  // await controller.onWeekdayChanged("Choose");
                  Get.back();
                },
              ),
              Divider(),
              ...weekdays.map((day) {
                return ListTile(
                  title: Text(day),
                  onTap: () async {
                    controller.selectedWeekday.value = day;
                    // await controller.onWeekdayChanged(day);
                    Get.back();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
