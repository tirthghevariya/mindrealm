import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/models/daily_reflection_model.dart';
import 'package:mindrealm/routers/app_routes.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/common_loader.dart';
import 'package:mindrealm/widgets/common_tost.dart';

class DailyReflectionController extends GetxController {
  Rx<String?> selectedValue = Rx<String?>(null);
  Rx<TextEditingController> wordController = TextEditingController().obs;
  Rx<TextEditingController> todayDescriptionController =
      TextEditingController().obs;
  Rx<DailyReflectionModel?> dailyReflectionModel =
      Rx<DailyReflectionModel?>(null);
  Rx<DailyReflectionEntry?> todayReflectionEntry =
      Rx<DailyReflectionEntry?>(null);

  final List<String> happinessScale =
      List.generate(10, (index) => '${index + 1}');

  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getUserDailyReflection();
    });
  }

  Future getUserDailyReflection() async {
    try {
      CommonLoader.showLoader();
      final doc = await dailyReflectionCollection
          .doc(firebaseUserId()) // current user UID
          .get();

      if (doc.exists && doc.data() != null) {
        dailyReflectionModel.value = DailyReflectionModel.fromFirestore(doc);
        // log("User reflections: ${dailyReflectionModel.value!.daily.map((e) => e.toMap()).toList()}");

        final today = DateTime.now();

        bool isSameDate(DateTime a, DateTime b) {
          return a.year == b.year && a.month == b.month && a.day == b.day;
        }

        final matchingEntries = dailyReflectionModel.value?.reflections.where(
          (entry) => isSameDate(entry.datetime, today),
        );

        if (matchingEntries != null && matchingEntries.isNotEmpty) {
          todayReflectionEntry.value = matchingEntries.first;
          log("Today's reflection: ${todayReflectionEntry.value!.toMap()}");
        }
        CommonLoader.hideLoader();
        if (todayReflectionEntry.value != null &&
            todayReflectionEntry.value!.todayDescription.isEmpty) {
          Get.toNamed(Routes.dailyGratitude);
          return;
        }
      } else {
        CommonLoader.hideLoader();

        log("No reflection document found for user.");
        todayReflectionEntry.value = null;
      }
    } catch (e) {
      CommonLoader.hideLoader();
      log('Error fetching daily reflection: $e');
      todayReflectionEntry.value = null;
    }
  }

  Future<void> nextStep() async {
    try {
      final docRef = dailyReflectionCollection.doc(firebaseUserId());

      if (todayReflectionEntry.value != null) {
        Get.toNamed(Routes.dailyGratitude);
        return;
      }

      // Use set() at the top level for serverTimestamp
      await docRef.set({
        'createdAt':
            FieldValue.serverTimestamp(), // top-level timestamp allowed
        'reflections': FieldValue.arrayUnion([
          {
            'todayDescription': "",
            'scaleNumber': selectedValue.value!,
            'feelingWord': wordController.value.text,
            'datetime': Timestamp.now(), // store current client time
          }
        ])
      }, SetOptions(merge: true));

      Get.toNamed(Routes.dailyGratitude);
    } catch (e) {
      log('Error saving daily reflection: $e');
      showToast('Failed to save reflection', err: true);
    }
  }

  Future<void> submitGratitude() async {
    try {
      final docRef = dailyReflectionCollection.doc(firebaseUserId());
      final snapshot = await docRef.get();

      if (!snapshot.exists || snapshot.data() == null) {
        log("No reflection document found.");
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final reflections = (data['reflections'] as List<dynamic>? ?? [])
          .map(
              (e) => DailyReflectionEntry.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      final today = DateTime.now();
      bool isSameDate(DateTime a, DateTime b) =>
          a.year == b.year && a.month == b.month && a.day == b.day;

      // Find today's reflection
      final index = reflections.indexWhere(
        (entry) => isSameDate(entry.datetime, today),
      );

      if (index != -1) {
        // Update only todayDescription
        reflections[index] = DailyReflectionEntry(
          datetime: reflections[index].datetime,
          scaleNumber: reflections[index].scaleNumber,
          feelingWord: reflections[index].feelingWord,
          todayDescription: wordController.value.text,
        );

        await docRef.update({
          'reflections': reflections.map((r) => r.toMap()).toList(),
        });

        log("Today's reflection updated successfully.");
        Get.toNamed(Routes.dailyGratitude);
      } else {
        log("No reflection found for today.");
      }
    } catch (e) {
      log('Error saving daily reflection: $e');
      showToast('Failed to save reflection', err: true);
    }
  }

  void handleSelection(int index) {
    selectedValue.value = happinessScale[index];
  }
}
