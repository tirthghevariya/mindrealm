import 'dart:async';
import 'dart:developer';

import 'package:carousel_slider/carousel_options.dart';
import 'package:get/get.dart';
import 'package:mindrealm/controllers/current_user_controller.dart';
import 'package:mindrealm/models/gole_model.dart';
import 'package:mindrealm/utils/app_assets.dart';
import 'package:mindrealm/utils/collection.dart';

class GoalController extends GetxController {
  CurrentUserController currentUserController =
      Get.find<CurrentUserController>();
  Rx<GoalsModel?> goalsData = Rx<GoalsModel?>(null); // Store full model

  RxList<String> slideshowImages = <String>[].obs;
  final currentImageIndex = 0.obs;

  void onSlideChanged(int index, CarouselPageChangedReason reason) {
    currentImageIndex.value = index;
  } // Inside your controller

  // Default fallback images
  final List<String> defaultImages = [
    AppImages.yourself,
    AppImages.health,
    AppImages.love,
    AppImages.career,
    AppImages.family,
    AppImages.friend,
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(Duration(seconds: 0), () async {
      await loadGoalData();
    });
  }

  Future<void> loadGoalData() async {
    try {
      final doc = await goalsCollection.doc(firebaseUserId()).get();

      if (doc.exists) {
        goalsData.value = GoalsModel.fromFirestore(doc);

        // ✅ Extract first image from each GoalCategory (if available)
        slideshowImages.clear();
        final gd = goalsData.value;
        if (gd != null) {
          final categories = [
            gd.career,
            gd.family,
            gd.friendships,
            gd.health,
            gd.love,
            gd.yourself,
          ];

          for (var cat in categories) {
            if (cat.images != null && cat.images!.isNotEmpty) {
              slideshowImages.add(cat.images!.first);
            }
          }
          log("slideshowImages: $slideshowImages");
        }
      }
    } catch (e) {
      log("Error loading goal data: $e");
    }
  }
}
