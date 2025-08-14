import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mindrealm/models/daily_reflection_model.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/common_loader.dart';

class WellBeingOverviewController extends GetxController {
  RxList<DailyReflectionEntry?> dailyReflectionData =
      <DailyReflectionEntry>[].obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      CommonLoader.showLoader();
      await addStaticDailyReflectionsToFirestore();
      await getUserDailyReflection();
      CommonLoader.hideLoader();
    });
  }

  Future<void> addStaticDailyReflectionsToFirestore() async {
    final userId = firebaseUserId(); // your current user id getter
    final docRef = dailyReflectionCollection.doc(userId);

    final startDate = DateTime(2025, 8, 10);
    final scaleNumbers = [3, 5, 4, 6, 2, 7, 5, 8, 6]; // test values

    final List<Map<String, dynamic>> reflections = [];

    for (int i = 0; i < scaleNumbers.length; i++) {
      reflections.add({
        "datetime": Timestamp.fromDate(startDate.add(Duration(days: i))),
        "feelingWord": "Feeling ${i + 1}",
        "scaleNumber": scaleNumbers[i].toString(),
        "todayDescription": "Description for day ${i + 1}",
      });
    }

    await docRef.set({
      "createdAt": FieldValue.serverTimestamp(),
      "reflections": reflections,
    }, SetOptions(merge: true));
  }

  Future getUserDailyReflection() async {
    try {
      final doc = await dailyReflectionCollection
          .doc(firebaseUserId()) // current user UID
          .get();

      if (doc.exists && doc.data() != null) {
        var data = DailyReflectionModel.fromFirestore(doc);
        dailyReflectionData.value = data.reflections
          ..sort((a, b) => b.datetime.compareTo(a.datetime));
      } else {
        log("No reflection document found for user.");
      }
    } catch (e) {
      log('Error fetching daily reflection: $e');
    }
  }
}
