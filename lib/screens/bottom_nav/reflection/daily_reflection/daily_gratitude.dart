import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/reflection_controllers/daily_reflection_controller.dart';

import 'package:mindrealm/utils/app_size_config.dart';
import 'package:mindrealm/widgets/common_tost.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';

class DailyGratitude extends GetView<DailyReflectionController> {
  const DailyGratitude({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.close(2);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.brown,
                      size: 32,
                    ))
              ],
            ),
          ),
          SizedBox(height: SizeConfig.getHeight(50)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(64)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.getHeight(80)),
                Center(
                  child: Text(
                    AppText.gratitudecheck,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 30,
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(80)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    AppText.inOneOrAFewWords,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.brown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(33)),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: controller.todayDescriptionController.value,
                    decoration: InputDecoration(
                      hintText: AppText.fillHere,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(20)),
                SizedBox(
                  height: SizeConfig.getWidth(40),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Border radius only
                      ),
                    ),
                    onPressed: () async {
                      if (controller
                          .todayDescriptionController.value.text.isEmpty) {
                        showToast(AppText.pleaseEnterGratitude);
                      }
                      await controller.submitGratitude();
                    },
                    child: Text(
                      AppText.continueTextDone,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
