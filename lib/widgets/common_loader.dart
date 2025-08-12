import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/utils/app_colors.dart';

class CommonLoader {
  static bool isLoaderShowing = false;

  static void showLoader() {
    if (!isLoaderShowing) {
      isLoaderShowing = true;
      // showDialog(
      //   context: Get.context!,
      //   builder: (BuildContext context) {
      //     return PopScope(
      //       canPop: false,
      //       child: Dialog(
      //         backgroundColor: Colors.transparent,
      //         child: circularLoder(),
      //       ),
      //     );
      //   },
      // );
      Get.dialog(
        PopScope(canPop: false, child: circularLoder()),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        useSafeArea: false,
      );
    }
  }

  static void hideLoader() {
    if (isLoaderShowing) {
      isLoaderShowing = false;
      Get.back();
    }
  }
}

Widget circularLoder() {
  return Center(
    child: /*  Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: kElevationToShadow[2],
          borderRadius: BorderRadius.circular(4)),
      child: */
        CircularProgressIndicator.adaptive(
      backgroundColor: Colors.grey,
      valueColor: AlwaysStoppedAnimation(AppColors.primary),
    ),
    /* ), */
  );
}
