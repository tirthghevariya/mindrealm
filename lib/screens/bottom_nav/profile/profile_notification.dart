import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';

class ProfileNotificationsScreen extends StatefulWidget {
  const ProfileNotificationsScreen({super.key});

  @override
  State<ProfileNotificationsScreen> createState() =>
      _ProfileNotificationsScreenState();
}

class _ProfileNotificationsScreenState
    extends State<ProfileNotificationsScreen> {
  final Map<String, bool> toggles = {
    AppText.dailyReminder: true,
    AppText.weeklyReminder: true,
    AppText.checkGoals: true,
    AppText.healSession: true,
  };

  bool isEditing = false;
  String name = "John Doe";
  String email = "johndoe@example.com";
  String birthday = "01/01/2000";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();

  String selectedWeekday = "Choose";

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
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Optional reset button
              ListTile(
                title: Text(
                  'Clear Selection',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedWeekday = "Choose";
                  });
                  Navigator.pop(context);
                },
              ),
              Divider(),
              // Days of the week
              ...weekdays.map((day) {
                return ListTile(
                  title: Text(day),
                  onTap: () {
                    setState(() {
                      selectedWeekday = day;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.profilebg,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getWidth(20),
              vertical: SizeConfig.getHeight(24),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.getHeight(12)),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back,
                        color: AppColors.brown, size: 32),
                  ),
                  SizedBox(height: SizeConfig.getHeight(12)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        _editableField(AppText.name, name, nameController),
                        SizedBox(height: SizeConfig.getHeight(18)),
                        _editableField(AppText.email, email, emailController),
                        SizedBox(height: SizeConfig.getHeight(18)),
                        _editableField(
                            AppText.birthday, birthday, birthdayController),
                        SizedBox(height: SizeConfig.getHeight(18)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isEditing = true;
                                  nameController.text = name;
                                  emailController.text = email;
                                  birthdayController.text = birthday;
                                });
                              },
                              child: Text(
                                AppText.editInfo,
                                style: GoogleFonts.openSans(
                                  fontSize: SizeConfig.getWidth(14),
                                  color: AppColors.brown,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isEditing) ...[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    name = nameController.text;
                                    email = emailController.text;
                                    birthday = birthdayController.text;
                                    isEditing = false;
                                  });
                                },
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
                        _toggleTile(AppText.dailyReminder),
                        _toggleTile(AppText.weeklyReminder),
                        _toggleTile(AppText.checkGoals),
                        _toggleTile(AppText.healSession),
                        SizedBox(height: SizeConfig.getHeight(20)),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Container(
                        //       width: SizeConfig.getWidth(230),
                        //       child: Text(
                        //         AppText.chooseDay,
                        //         style: GoogleFonts.openSans(
                        //           fontSize: SizeConfig.getWidth(14),
                        //           color: AppColors.brown,
                        //           fontWeight: FontWeight.w700,
                        //         ),
                        //       ),
                        //     ),
                        //     Text(
                        //       AppText.choose,
                        //       style: GoogleFonts.openSans(
                        //         fontSize: SizeConfig.getWidth(14),
                        //         color: AppColors.brown,
                        //         decoration: TextDecoration.underline,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
                                selectedWeekday,
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
                                  onPressed: () {},
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
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editableField(
      String label, String value, TextEditingController controller) {
    return Row(
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
        isEditing
            ? Expanded(
                child: TextField(
                  controller: controller,
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
                  value,
                  style: GoogleFonts.openSans(
                    fontSize: SizeConfig.getWidth(14),
                    color: AppColors.brown,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _toggleTile(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.getHeight(12)),
      child: Row(
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
            value: toggles[title] ?? false,
            activeColor: AppColors.brown,
            inactiveThumbColor: AppColors.brown.withOpacity(0.5),
            onChanged: (value) {
              setState(() {
                toggles[title] = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
