// views/weekly_reflection_view.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/reflection_controllers/weekly_reflection_controller.dart';
import 'package:mindrealm/utils/app_colors.dart';
import 'package:mindrealm/utils/app_size_config.dart';
import 'package:mindrealm/utils/app_text.dart';

class WeeklyReflection extends GetView<WeeklyReflectionController> {
  const WeeklyReflection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: Obx(() {
        if (controller.hasCompletedThisWeek.value) {
          return _buildCompletedView();
        }

        return _buildCategoryView();
      }),
    );
  }

  Widget _buildCompletedView() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(40)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 80,
                    color: AppColors.brown,
                  ),
                  SizedBox(height: SizeConfig.getHeight(30)),
                  Text(
                    'Weekly Reflection Complete!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 28,
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getHeight(20)),
                  Text(
                    controller.statusMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.brown,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryView() {
    return Column(
      children: [
        _buildHeader(),
        _buildProgressIndicator(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(24)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.getHeight(30)),
                _buildCategoryTitle(),
                SizedBox(height: SizeConfig.getHeight(60)),
                _buildRatingQuestion(),
                SizedBox(height: SizeConfig.getHeight(40)),
                _buildRatingSelector(),
                SizedBox(height: SizeConfig.getHeight(63)),
                _buildNotePrompt(),
                SizedBox(height: SizeConfig.getHeight(33)),
                _buildNoteInput(),
                SizedBox(height: SizeConfig.getHeight(70)),
                _buildActionButtons(),
                SizedBox(height: SizeConfig.getHeight(30)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: AppColors.brown, size: 32),
          ),
          Spacer(),
          if (!controller.hasCompletedThisWeek.value)
            Text(
              'Question ${controller.progressText}',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.brown,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (controller.hasCompletedThisWeek.value) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(24)),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.getHeight(10)),
          LinearProgressIndicator(
            value: controller.progressPercentage,
            backgroundColor: AppColors.brown.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.brown),
            minHeight: 4,
          ),
          SizedBox(height: SizeConfig.getHeight(10)),
        ],
      ),
    );
  }

  Widget _buildCategoryTitle() {
    return Obx(() => Text(
          controller.currentQuestion.value,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 30,
            color: AppColors.primary,
            fontStyle: FontStyle.italic,
          ),
        ));
  }

  Widget _buildRatingQuestion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'How content are you on a scale from 1-10?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.brown,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildRatingSelector() {
    return Obx(() => GestureDetector(
          onTap: () {
            showCupertinoModalPopup(
              context: Get.context!,
              builder: (_) => Container(
                height: 250,
                color: Colors.white,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: controller.selectedValue.value != null
                        ? controller.ratingScale
                            .indexOf(controller.selectedValue.value!)
                        : 0,
                  ),
                  onSelectedItemChanged: controller.handleSelection,
                  children: controller.ratingScale
                      .map((value) => Center(child: Text(value)))
                      .toList(),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: controller.selectedValue.value != null
                      ? AppColors.brown
                      : AppColors.brown.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedValue.value ?? 'Select a rating',
                  style: TextStyle(
                    color: controller.selectedValue.value != null
                        ? AppColors.brown
                        : AppColors.brown.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.brown,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildNotePrompt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Add a word or note about this area of your life',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.brown,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildNoteInput() {
    return Obx(() => TextField(
          controller: controller.wordController.value,
          onChanged: (e) {
            controller.wordController.refresh();
          },
          decoration: InputDecoration(
            hintText: 'Type your note here...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.brown),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ));
  }

  Widget _buildActionButtons() {
    return Obx(() => Column(
          children: [
            // Main action button
            SizedBox(
              width: double.infinity,
              height: SizeConfig.getWidth(40),
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : (controller.isCurrentQuestionValid
                        ? controller.submitCurrentAnswer
                        : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isCurrentQuestionValid &&
                          !controller.isSubmitting.value
                      ? AppColors.brown
                      : AppColors.brown.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        controller.isLastCategory
                            ? "Complete Reflection"
                            : "Continue",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),

            // Previous button (if not first category)
            if (!controller.isFirstCategory) ...[
              SizedBox(height: SizeConfig.getHeight(16)),
              TextButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.goToPreviousCategory,
                child: Text(
                  'Previous Question',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ));
  }
}
