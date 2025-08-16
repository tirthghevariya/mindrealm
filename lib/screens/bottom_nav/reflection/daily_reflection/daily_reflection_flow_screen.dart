import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/reflection_controllers/daily_reflection_controller.dart';
import 'package:mindrealm/utils/app_size_config.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';

class DailyReflectionFlowScreen extends GetView<DailyReflectionController> {
  const DailyReflectionFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      resizeToAvoidBottomInset: true,
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.brown,
                      size: 32,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(50)),
            controller.todayReflectionEntry.value != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppText.alreadySubmitData,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 30,
                          color: AppColors.primary,
                          fontStyle: FontStyle.italic,
                          height: 1,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getWidth(64)),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  AppText.howAreYouFeelingToday,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 30,
                                    color: AppColors.primary,
                                    fontStyle: FontStyle.italic,
                                    height: 1,
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.getHeight(80)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  AppText.howContentQuestion,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.brown,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.getHeight(40)),

                              // 👇 Cupertino-style number scroll picker
                              GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => Container(
                                      height: 250,
                                      color: Colors.white,
                                      child: CupertinoPicker(
                                        backgroundColor: Colors.white,
                                        itemExtent: 40,
                                        scrollController:
                                            FixedExtentScrollController(
                                          initialItem:
                                              controller.selectedValue.value !=
                                                      null
                                                  ? controller.happinessScale
                                                      .indexOf(controller
                                                          .selectedValue.value!)
                                                  : 0,
                                        ),
                                        onSelectedItemChanged: (value) {
                                          controller.handleSelection(value);
                                        },
                                        children: controller.happinessScale
                                            .map((value) =>
                                                Center(child: Text(value)))
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightPrimary,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.brown),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.selectedValue.value ??
                                            AppText.selectScale,
                                        style: TextStyle(
                                          color: AppColors.brown,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down,
                                          color: AppColors.brown),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: SizeConfig.getHeight(63)),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  AppText.addWordPrompt,
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
                                height: SizeConfig.getWidth(40),
                                child: Obx(
                                  () => TextField(
                                    controller:
                                        controller.feelingWordController.value,
                                    onChanged: (value) {
                                      controller.feelingWordController
                                          .refresh();
                                    },
                                    decoration: InputDecoration(
                                      hintText: AppText.fillHere,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 14),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.getHeight(20)),
                            ],
                          ),
                          SizedBox(height: SizeConfig.getHeight(30)),
                          Obx(
                            () => SizedBox(
                              height: SizeConfig.getWidth(40),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.selectedValue.value != null &&
                                              controller.feelingWordController
                                                  .value.text.isNotEmpty
                                          ? AppColors.brown
                                          : AppColors.brown
                                              .withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed:
                                    controller.selectedValue.value != null &&
                                            controller.feelingWordController
                                                .value.text.isNotEmpty
                                        ? controller.nextStep
                                        : null,
                                child: Text(
                                  AppText.continueText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
