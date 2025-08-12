import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/goal_detail_controller.dart';
import 'package:mindrealm/models/gole_model.dart';
import 'package:mindrealm/utils/app_assets.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/select_picker_type_diaog.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';

class GoalDetailScreen extends GetView<GoalDetailController> {
  const GoalDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.getHeight(24)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getHeight(30),
                      vertical: SizeConfig.getHeight(24),
                    ),
                    child: SizedBox(
                      height: SizeConfig.screenHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.getCategoryName().capitalizeFirst!,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              color: AppColors.brown,
                              height: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(16)),
                          TabBar(
                            controller: controller.tabController,
                            dividerColor: AppColors.lightPrimary,
                            indicatorColor: Colors.transparent,
                            dividerHeight: 0,
                            padding: EdgeInsets.zero,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            onTap: (index) {
                              controller.tabController.index = index;
                              controller.loadGoalData();
                            },
                            tabs:
                                List.generate(controller.icons.length, (index) {
                              final isSelected =
                                  controller.tabController.index == index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.8)
                                      : AppColors.white.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  controller.icons[index],
                                  width: 24,
                                  height: 24,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: SizeConfig.getHeight(20)),
                          Expanded(
                            child: ListView(
                              children: [
                                editableField(
                                  0,
                                  AppText.goalLabel,
                                  AppText.goalHint,
                                  AppColors.brown,
                                ),
                                SizedBox(height: SizeConfig.getHeight(26)),
                                editableField(
                                  1,
                                  AppText.affirmation,
                                  AppText.affirmationHint,
                                  AppColors.primary,
                                ),
                                SizedBox(height: SizeConfig.getHeight(30)),
                                editableField(
                                  2,
                                  AppText.continueLabel,
                                  AppText.continueHint,
                                  AppColors.primary,
                                  hintColor: Colors.orange,
                                ),
                                SizedBox(height: SizeConfig.getHeight(30)),
                                editableField(
                                  3,
                                  AppText.improveLabel,
                                  AppText.improveHint,
                                  AppColors.primary,
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppText.youGotThis,
                                      style: GoogleFonts.dmSerifDisplay(
                                        fontSize: 24,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                        color: AppColors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppText.moodboard,
                                      style: GoogleFonts.openSans(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.getHeight(16)),
                                GridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.8,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      ...List.generate(
                                          controller.selectedTabImages.length,
                                          (index) {
                                        return Container(
                                          height: SizeConfig.getHeight(160),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.4),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.network(
                                                controller
                                                    .selectedTabImages[index],
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Icon(Icons.error),
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                right: 8,
                                                child: Icon(
                                                  Icons.delete,
                                                  color: AppColors.white,
                                                  size: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      if (controller
                                              .selectedTabImages.isEmpty ||
                                          controller.selectedTabImages.length !=
                                              4)
                                        GestureDetector(
                                          onTap: () async {
                                            await Get.dialog(
                                                const SelectPickerTypeDiaog(
                                              isForPostImage: true,
                                            ));
                                          },
                                          child: Container(
                                            height: SizeConfig.getHeight(160),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.4),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Icon(Icons.image,
                                                size: 50, color: Colors.white),
                                          ),
                                        )
                                    ]),
                                SizedBox(height: SizeConfig.getHeight(40)),
                                Image.asset(
                                  AppImages.logo,
                                  width: SizeConfig.getWidth(216),
                                  height: SizeConfig.getHeight(108),
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  Widget editableField(
    // GoalDetailScreen controller,
    int index,
    String label,
    String hint,
    Color textColor, {
    Color hintColor = Colors.grey,
  }) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: index == 0 ? 20 : 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            controller.isEditing[index]
                ? TextField(
                    controller: controller.controllers[index],
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: AppColors.brown,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(14),
                      hintText: hint,
                      hintStyle: GoogleFonts.openSans(
                        fontSize: 14,
                        color: hintColor,
                      ),
                      filled: true,
                      fillColor: AppColors.lightPrimary,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.getWidth(4)),
                    child: Text(
                      controller.controllers[index].text.isEmpty
                          ? hint
                          : controller.controllers[index].text,
                      style: GoogleFonts.openSans(
                        fontSize: index == 0 ? 20 : 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
            InkWell(
              onTap: () async {
                controller.isEditing[index] = !controller.isEditing[index];
                if (!controller.isEditing[index]) {
                  await controller.saveIndividualField(index);
                }
              },
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      controller.isEditing[index] ? AppText.done : AppText.edit,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: index == 0 ? AppColors.brown : Colors.orange,
                      ),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: (controller.isEditing[index]
                                ? AppText.done
                                : AppText.edit)
                            .length *
                        6,
                    color: index == 0 ? AppColors.red : Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
