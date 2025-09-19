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
  Rx<TextEditingController> feelingWordController = TextEditingController().obs;
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
      // await addStaticReflections();
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
            'feelingWord': feelingWordController.value.text,
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
      CommonLoader.showLoader();
      final docRef = dailyReflectionCollection.doc(firebaseUserId());
      final snapshot = await docRef.get();

      if (!snapshot.exists || snapshot.data() == null) {
        log("No reflection document found.");
        CommonLoader.hideLoader();

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
          todayDescription: todayDescriptionController.value.text,
        );

        await docRef.update({
          'reflections': reflections.map((r) => r.toMap()).toList(),
        });
        CommonLoader.hideLoader();

        showToast("Today's reflection updated successfully.");
        Get.close(2);
        CommonLoader.hideLoader();
      } else {
        log("No reflection found for today.");
      }
      CommonLoader.hideLoader();
    } catch (e) {
      log('Error saving daily reflection: $e');
      showToast('Failed to save reflection', err: true);
    }
  }

  void handleSelection(int index) {
    selectedValue.value = happinessScale[index];
  }

//  static data for testing

  /*  final List<Map<String, dynamic>> staticReflections = [
    {
      'datetime': DateTime(2025, 9, 10, 9, 0),
      'feelingWord': "happy",
      'scaleNumber': "8",
      'todayDescription': "Had a productive morning."
    },
    {
      'datetime': DateTime(2025, 9, 11, 10, 30),
      'feelingWord': "tired",
      'scaleNumber': "4",
      'todayDescription': "Worked late, need rest."
    },
    {
      'datetime': DateTime(2025, 9, 12, 7, 45),
      'feelingWord': "excited",
      'scaleNumber': "9",
      'todayDescription': "Looking forward to the weekend."
    },
    {
      'datetime': DateTime(2025, 9, 13, 20, 15),
      'feelingWord': "calm",
      'scaleNumber': "7",
      'todayDescription': "Relaxed day with family."
    },
    {
      'datetime': DateTime(2025, 9, 14, 13, 0),
      'feelingWord': "stressed",
      'scaleNumber': "3",
      'todayDescription': "Deadlines piling up."
    },
  ];

  Future<void> addStaticReflections() async {
    try {
      final docRef = dailyReflectionCollection.doc(firebaseUserId());

      // Convert DateTime to Firestore Timestamp
      final reflectionsWithTimestamps = staticReflections.map((e) {
        return {
          'datetime': Timestamp.fromDate(e['datetime'] as DateTime),
          'feelingWord': e['feelingWord'],
          'scaleNumber': e['scaleNumber'],
          'todayDescription': e['todayDescription'],
        };
      }).toList();

      await docRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'reflections': FieldValue.arrayUnion(reflectionsWithTimestamps),
      }, SetOptions(merge: true));

      log("✅ Static reflections added successfully");
      showToast("Static reflections added successfully.");
    } catch (e) {
      log("❌ Error adding static reflections: $e");
      showToast("Failed to add static reflections", err: true);
    }
  } */
}
