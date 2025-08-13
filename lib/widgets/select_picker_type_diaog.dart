import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindrealm/controllers/goal_detail_controller.dart';
import 'package:mindrealm/service/goal_image_service.dart';
import 'package:mindrealm/utils/app_colors.dart';
import 'package:mindrealm/utils/app_text.dart';
import 'package:mindrealm/widgets/common_button.dart';

class SelectPickerTypeDiaog extends GetView<GoalDetailController> {
  final bool isForPostImage;

  const SelectPickerTypeDiaog({
    super.key,
    this.isForPostImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final UserGoalService postService = Get.find<UserGoalService>();

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isForPostImage ? AppText.addPosts : AppText.chooseImage,
                      style: const TextStyle(fontSize: 16)),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.primary,
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                color: AppColors.lightPrimaryBg,
                padding: const EdgeInsets.all(12),
                child: Column(
                  spacing: 8,
                  children: [
                    InkWell(
                      onTap: () async {
                        Get.back();
                        if (isForPostImage) {
                          final File? image = await postService.pickImage(
                              source: ImageSource.camera);
                          if (image != null) {
                            // Show caption dialog
                            await Get.dialog(
                                PostCaptionDialog(imageFile: image));
                          }
                        } else {}
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          spacing: 12,
                          children: [
                            // SvgPicture.asset(CommonImagePath.cameraIcons),
                            Icon(Icons.camera),
                            Text(AppText.openCamera)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                        if (isForPostImage) {
                          final File? image = await postService.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            // Show caption dialog
                            await Get.dialog(
                                PostCaptionDialog(imageFile: image));
                          }
                        } else {}
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          spacing: 12,
                          children: [
                            // SvgPicture.asset(CommonImagePath.galleryIcons),
                            Icon(Icons.photo),
                            Text(AppText.selectFromGallery),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class PostCaptionDialog extends StatelessWidget {
  final File imageFile;

  PostCaptionDialog({
    super.key,
    required this.imageFile,
  });
  final UserGoalService postService = Get.find<UserGoalService>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: AppColors.background,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppText.addPosts,
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.primary,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            // Image preview
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Caption field

            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    text: AppText.cancel,
                    onTap: () {
                      Get.back();
                    },
                    borderColor: AppColors.primary,
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.primary,
                    // boxShadow: null,
                    isboxShodow: false,
                    outline: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CommonButton(
                    text: AppText.post,
                    isboxShodow: false,
                    onTap: () async {
                      await postService.loadGoalPosts();

                      await postService.uploadPostImage(
                        imageFile,
                      );
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
