import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/common_loader.dart';
import 'package:mindrealm/widgets/common_tost.dart';
import '../../models/weekly_reflection_model.dart';

class WeeklyReflectionController extends GetxController {
  // UI State
  Rx<String?> selectedValue = Rx<String?>(null);
  final wordController = TextEditingController().obs;
  final List<String> ratingScale = List.generate(10, (index) => '${index + 1}');

  // Reflection State
  RxInt currentCategoryIndex = 0.obs;
  // RxBool isLoading = true.obs;
  RxBool isSubmitting = false.obs;
  RxBool hasCompletedThisWeek = false.obs;
  RxString statusMessage = ''.obs;

  // Current reflection data
  Rx<WeeklyReflectionDocument?> currentWeekReflection =
      Rx<WeeklyReflectionDocument?>(null);
  RxString currentCategory = ''.obs;
  RxString currentQuestion = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await initializeReflection();
    });
  }

  @override
  void onClose() {
    wordController.value.dispose();
    super.onClose();
  }

  Future<void> initializeReflection() async {
    CommonLoader.showLoader();
    try {
      String currentWeekId = WeeklyReflectionService.getCurrentWeekId();

      // Get current week's reflection document
      WeeklyReflectionDocument? weeklyReflection =
          await WeeklyReflectionService.getWeeklyReflection(
              firebaseUserId(), currentWeekId);

      if (weeklyReflection != null) {
        currentWeekReflection.value = weeklyReflection;

        if (weeklyReflection.isComplete) {
          hasCompletedThisWeek.value = true;
          statusMessage.value =
              "You've already completed this week's reflection. Come back next week for a new one!";
        } else {
          // Find the next incomplete category
          findNextIncompleteCategory();
          loadExistingAnswer();
        }
      } else {
        // Start fresh
        currentCategoryIndex.value = 0;
        loadCurrentCategory();
      }
    } catch (e) {
      CommonLoader.hideLoader();

      showToast("Failed to load reflection data: ${e.toString()}", err: true);
    } finally {
      CommonLoader.hideLoader();
    }
  }

  void findNextIncompleteCategory() {
    List<String> categories = ReflectionCategories.categoryKeys;

    for (int i = 0; i < categories.length; i++) {
      String category = categories[i];
      if (!currentWeekReflection.value!.reflections.containsKey(category)) {
        currentCategoryIndex.value = i;
        loadCurrentCategory();
        return;
      }
    }

    // All categories are complete
    currentCategoryIndex.value = categories.length - 1;
    loadCurrentCategory();
  }

  void loadCurrentCategory() {
    List<String> categories = ReflectionCategories.categoryKeys;
    if (currentCategoryIndex.value < categories.length) {
      currentCategory.value = categories[currentCategoryIndex.value];
      currentQuestion.value =
          ReflectionCategories.categories[currentCategory.value]!;
    }
  }

  void loadExistingAnswer() {
    if (currentWeekReflection.value?.reflections
            .containsKey(currentCategory.value) ==
        true) {
      ReflectionEntry entry =
          currentWeekReflection.value!.reflections[currentCategory.value]!;
      selectedValue.value = entry.rating.toString();
      wordController.value.text = entry.note;
    } else {
      selectedValue.value = null;
      wordController.value.clear();
    }
  }

  void handleSelection(int index) {
    selectedValue.value = ratingScale[index];
  }

  bool get isCurrentQuestionValid {
    return selectedValue.value != null &&
        selectedValue.value!.isNotEmpty &&
        wordController.value.text.trim().isNotEmpty;
  }

  Future<void> submitCurrentAnswer() async {
    if (!isCurrentQuestionValid) {
      showToast('Please complete all fields before continuing', err: true);

      return;
    }

    isSubmitting.value = true;

    try {
      bool success = await WeeklyReflectionService.updateReflectionEntry(
        userId: firebaseUserId(),
        category: currentCategory.value,
        rating: int.parse(selectedValue.value!),
        note: wordController.value.text.trim(),
      );

      if (success) {
        // Refresh current reflection data
        String currentWeekId = WeeklyReflectionService.getCurrentWeekId();
        currentWeekReflection.value =
            await WeeklyReflectionService.getWeeklyReflection(
                firebaseUserId(), currentWeekId);

        // Check if this was the last category
        if (isLastCategory && currentWeekReflection.value!.isComplete) {
          // Completed all categories

          showToast('Weekly reflection completed! Thank you for sharing.');
          hasCompletedThisWeek.value = true;
          statusMessage.value =
              "You've completed this week's reflection. Come back next week for a new one!";
        } else {
          // Move to next category
          _moveToNextCategory();
          showToast('Answer saved! Moving to next question.');
        }
      } else {
        showToast('Failed to save answer. Please try again.', err: true);
      }
    } catch (e) {
      showToast('Failed to submit answer: ${e.toString()}', err: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _moveToNextCategory() {
    // Clear current answers
    selectedValue.value = null;
    wordController.value.clear();

    // Move to next category
    currentCategoryIndex.value++;

    if (currentCategoryIndex.value < ReflectionCategories.categoryKeys.length) {
      loadCurrentCategory();
      loadExistingAnswer();
    }
  }

  void goToPreviousCategory() {
    if (currentCategoryIndex.value > 0) {
      currentCategoryIndex.value--;
      loadCurrentCategory();
      loadExistingAnswer();
    }
  }

  String get progressText {
    int total = ReflectionCategories.categoryKeys.length;
    int current = currentCategoryIndex.value + 1;
    return '$current of $total';
  }

  double get progressPercentage {
    return (currentCategoryIndex.value + 1) /
        ReflectionCategories.categoryKeys.length;
  }

  bool get isLastCategory {
    return currentCategoryIndex.value >=
        ReflectionCategories.categoryKeys.length - 1;
  }

  bool get isFirstCategory {
    return currentCategoryIndex.value <= 0;
  }

  // Get user's reflection history
  Future<List<WeeklyReflectionDocument>> getReflectionHistory() async {
    try {
      return await WeeklyReflectionService.getUserReflectionHistory(
          firebaseUserId());
    } catch (e) {
      log('Error getting reflection history: $e');
      return [];
    }
  }
}

class WeeklyReflectionService {
  // Get current week ID (format: YYYY_WW)
  static String getCurrentWeekId() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    int weekNumber = getWeekNumber(startOfWeek);
    return '${startOfWeek.year}_${weekNumber.toString().padLeft(2, '0')}';
  }

  // Get week start and end dates
  static Map<String, DateTime> getWeekDates([DateTime? date]) {
    DateTime targetDate = date ?? DateTime.now();
    DateTime startOfWeek =
        targetDate.subtract(Duration(days: targetDate.weekday - 1));
    DateTime endOfWeek =
        startOfWeek.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    return {
      'start': DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      'end':
          DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
    };
  }

  static int getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(
            date.difference(DateTime(date.year, 1, 1)).inDays.toString()) +
        1;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  // Get user's weekly reflections document
  static Future<Map<String, WeeklyReflectionDocument>?>
      getUserWeeklyReflections(String userId) async {
    try {
      DocumentSnapshot doc =
          await weeklyReflectionsCollection.doc(userId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, WeeklyReflectionDocument> weeklyReflections = {};

        data.forEach((weekId, weekData) {
          if (weekData is Map<String, dynamic>) {
            weeklyReflections[weekId] =
                WeeklyReflectionDocument.fromMap(weekId, weekData);
          }
        });

        return weeklyReflections;
      }
      return null;
    } catch (e) {
      log('Error getting user weekly reflections: $e');
      return null;
    }
  }

  // Get specific week's reflection
  static Future<WeeklyReflectionDocument?> getWeeklyReflection(
      String userId, String weekId) async {
    try {
      Map<String, WeeklyReflectionDocument>? allReflections =
          await getUserWeeklyReflections(userId);
      return allReflections?[weekId];
    } catch (e) {
      log('Error getting weekly reflection: $e');
      return null;
    }
  }

  // Update or create a reflection entry
  static Future<bool> updateReflectionEntry({
    required String userId,
    required String category,
    required int rating,
    required String note,
  }) async {
    try {
      String currentWeekId = getCurrentWeekId();
      Map<String, DateTime> weekDates = getWeekDates();

      DocumentReference userReflectionRef =
          weeklyReflectionsCollection.doc(userId);

      // Create reflection entry
      ReflectionEntry entry = ReflectionEntry(rating: rating, note: note);

      // Check if document exists
      DocumentSnapshot doc = await userReflectionRef.get();

      if (doc.exists) {
        // Check if this week exists
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey(currentWeekId)) {
          // Update existing week's reflection
          await userReflectionRef.update({
            '$currentWeekId.reflections.$category': entry.toMap(),
            '$currentWeekId.updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Create new week entry
          await userReflectionRef.update({
            currentWeekId: {
              'startDate': Timestamp.fromDate(weekDates['start']!),
              'endDate': Timestamp.fromDate(weekDates['end']!),
              'reflections': {
                category: entry.toMap(),
              },
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            }
          });
        }
      } else {
        // Create new document with first week entry
        await userReflectionRef.set({
          currentWeekId: {
            'startDate': Timestamp.fromDate(weekDates['start']!),
            'endDate': Timestamp.fromDate(weekDates['end']!),
            'reflections': {
              category: entry.toMap(),
            },
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }
        });
      }

      return true;
    } catch (e) {
      log('Error updating reflection entry: $e');
      return false;
    }
  }

  // Get user's reflection history
  static Future<List<WeeklyReflectionDocument>> getUserReflectionHistory(
      String userId) async {
    try {
      Map<String, WeeklyReflectionDocument>? allReflections =
          await getUserWeeklyReflections(userId);

      if (allReflections == null) return [];

      List<WeeklyReflectionDocument> reflectionsList =
          allReflections.values.toList();
      reflectionsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return reflectionsList;
    } catch (e) {
      log('Error getting reflection history: $e');
      return [];
    }
  }

  // Check if user has completed current week
  static Future<bool> hasCompletedCurrentWeek(String userId) async {
    try {
      String currentWeekId = getCurrentWeekId();
      WeeklyReflectionDocument? reflection =
          await getWeeklyReflection(userId, currentWeekId);

      return reflection?.isComplete ?? false;
    } catch (e) {
      log('Error checking completion status: $e');
      return false;
    }
  }

  // Get reflection statistics
  static Future<Map<String, dynamic>> getReflectionStats(String userId) async {
    try {
      List<WeeklyReflectionDocument> history =
          await getUserReflectionHistory(userId);

      if (history.isEmpty) {
        return {
          'totalWeeks': 0,
          'averageRatings': <String, double>{},
          'completionRate': 0.0,
        };
      }

      Map<String, List<int>> categoryRatings = {};
      int completedWeeks = 0;

      for (WeeklyReflectionDocument reflection in history) {
        if (reflection.isComplete) completedWeeks++;

        reflection.reflections.forEach((category, entry) {
          if (!categoryRatings.containsKey(category)) {
            categoryRatings[category] = [];
          }
          categoryRatings[category]!.add(entry.rating);
        });
      }

      Map<String, double> averageRatings = {};
      categoryRatings.forEach((category, ratings) {
        averageRatings[category] =
            ratings.reduce((a, b) => a + b) / ratings.length;
      });

      return {
        'totalWeeks': history.length,
        'completedWeeks': completedWeeks,
        'averageRatings': averageRatings,
        'completionRate': completedWeeks / history.length,
      };
    } catch (e) {
      log('Error getting reflection stats: $e');
      return {
        'totalWeeks': 0,
        'averageRatings': <String, double>{},
        'completionRate': 0.0,
      };
    }
  }
}
