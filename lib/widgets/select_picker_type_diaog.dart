// import 'package:challenging/Constants/common_colors.dart';
// import 'package:challenging/Constants/common_image_path.dart';
// import 'package:challenging/Constants/common_string.dart';
// import 'package:challenging/Constants/text_style.dart';
// import 'package:challenging/Controllers/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

// class SelectPickerTypeDiaog extends GetView<ProfileController> {
//   const SelectPickerTypeDiaog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         backgroundColor: CommonColors.cardColor,
//         elevation: 0,
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: CommonColors.cardColor,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 8,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   boldText(CommonString.addPosts, fontsize: 16),
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Icon(
//                       Icons.close,
//                       color: CommonColors.primaryColor,
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                 width: double.infinity,
//                 color: CommonColors.cardBackgroundColor,
//                 padding: EdgeInsets.all(12),
//                 child: Column(
//                   spacing: 8,
//                   children: [
//                     Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                           color: CommonColors.cardColor,
//                           borderRadius: BorderRadius.circular(6)),
//                       child: Row(
//                         spacing: 12,
//                         children: [
//                           SvgPicture.asset(CommonImagePath.cameraIcons),
//                           semiBoldText(CommonString.openCamera)
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                           color: CommonColors.cardColor,
//                           borderRadius: BorderRadius.circular(6)),
//                       child: Row(
//                         spacing: 12,
//                         children: [
//                           SvgPicture.asset(CommonImagePath.galleryIcons),
//                           semiBoldText(CommonString.selectFromGallery)
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindrealm/controllers/goal_detail_controller.dart';
import 'package:mindrealm/service/goal_image_service.dart';
import 'package:mindrealm/utils/app_colors.dart';
import 'package:mindrealm/utils/app_text.dart';

class SelectPickerTypeDiaog extends GetView<GoalDetailController> {
  final bool isForPostImage;

  const SelectPickerTypeDiaog({
    super.key,
    this.isForPostImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final UserGoalService userGoalService = Get.find<UserGoalService>();

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // backgroundColor: CommonColors.cardColor,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // color: CommonColors.cardColor,
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
                  Text(
                    AppText.chooseImage,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              Container(
                width: double.infinity,
                color: AppColors.lightPrimary,
                padding: const EdgeInsets.all(12),
                child: Column(
                  spacing: 8,
                  children: [
                    InkWell(
                      onTap: () async {
                        Get.back();
                        if (isForPostImage) {
                          final File? image = await userGoalService.pickImage(
                              source: ImageSource.camera);
                          if (image != null) {
                            // Show caption dialog
                            Get.dialog(PostCaptionDialog(imageFile: image));
                          }
                        } else {
                          // Original profile image flow
                          await controller.pickProfileImage();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color: CommonColors.cardColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          spacing: 12,
                          children: [
                            SvgPicture.asset(CommonImagePath.cameraIcons),
                            semiBoldText(CommonString.openCamera)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                        if (isForPostImage) {
                          final File? image = await userGoalService.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            // Show caption dialog
                            Get.dialog(PostCaptionDialog(imageFile: image));
                          }
                        } else {
                          // Original profile image flow
                          await controller.pickProfileImage();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color: CommonColors.cardColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          spacing: 12,
                          children: [
                            SvgPicture.asset(CommonImagePath.galleryIcons),
                            semiBoldText(CommonString.selectFromGallery)
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

  const PostCaptionDialog({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    final UserGoalService userGoalService = Get.find<UserGoalService>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: CommonColors.cardColor,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CommonColors.cardColor,
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
                boldText(CommonString.addPosts, fontsize: 16),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: CommonColors.primaryColor,
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
                    text: CommonString.cancel,
                    onTap: () {
                      Get.back();
                    },
                    borderColor: CommonColors.primaryColor,
                    backgroundColor: Colors.transparent,
                    textColor: CommonColors.primaryColor,
                    // boxShadow: null,
                    isboxShodow: false,
                    outline: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CommonButton(
                    text: CommonString.post,
                    isboxShodow: false,
                    onTap: () async {
                      await userGoalService.uploadPostImage(
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
