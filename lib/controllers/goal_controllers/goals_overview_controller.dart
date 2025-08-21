import 'dart:developer';

import 'package:get/get.dart';
import 'package:mindrealm/models/gole_model.dart';
import 'package:mindrealm/utils/app_text.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/common_loader.dart';

class GoalsOverviewController extends GetxController {
  Rx<GoalsModel?> goalsData = Rx<GoalsModel?>(null); // Store full model
  RxList<String> goalDescriptions = <String>[].obs;

  // Dummy goal data from each category (Replace with actual shared state or DB)
  final List<String> goalTitles = [
    AppText.goalForYourself,
    AppText.goalForHealth,
    AppText.goalForLove,
    AppText.goalForCareer,
    AppText.goalForFamily,
    AppText.goalForFriendships,
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(Duration(seconds: 0), () async {
      await loadGoalData();
    });
  }

  Future<void> loadGoalData({bool isLoading = true}) async {
    try {
      if (isLoading) {
        CommonLoader.showLoader();
      }
      final doc = await goalsCollection.doc(firebaseUserId()).get();

      if (doc.exists) {
        goalsData.value = GoalsModel.fromFirestore(doc);

        // ✅ Extract first image from each GoalCategory (if available)
        goalDescriptions.clear();
        final gd = goalsData.value;
        if (gd != null) {
          final categories = [
            gd.yourself,
            gd.health,
            gd.love,
            gd.career,
            gd.family,
            gd.friendships,
          ];

          for (var cat in categories) {
            // if (cat.goal.isNotEmpty) {
            goalDescriptions.add(cat.goal);
            // }
          }
          log("slideshowImages: $goalDescriptions");
        }
        if (isLoading) {
          CommonLoader.hideLoader();
        }
      } else {
        if (isLoading) {
          CommonLoader.hideLoader();
        }
      }
    } catch (e) {
      if (isLoading) {
        CommonLoader.hideLoader();
      }
      log("Error loading goal data: $e");
    }
  }
}
