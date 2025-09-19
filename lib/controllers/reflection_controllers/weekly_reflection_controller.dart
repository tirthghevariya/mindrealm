import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      // await WeeklyReflectionService.addStaticDemoData(firebaseUserId());
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

        // Check if all categories are completed manually
        List<String> allCategories = ReflectionCategories.categoryKeys;
        bool allCategoriesComplete = allCategories.every(
            (category) => weeklyReflection.reflections.containsKey(category));

        if (allCategoriesComplete) {
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

  // Updated validation - only rating is required, note is optional
  bool get isCurrentQuestionValid {
    return selectedValue.value != null && selectedValue.value!.isNotEmpty;
  }

  Future<void> submitCurrentAnswer() async {
    if (!isCurrentQuestionValid) {
      showToast('Please select a rating before continuing', err: true);
      return;
    }

    isSubmitting.value = true;

    try {
      bool success = await WeeklyReflectionService.updateReflectionEntry(
        userId: firebaseUserId(),
        category: currentCategory.value,
        rating: int.parse(selectedValue.value!),
        note: wordController.value.text.trim(), // Can be empty now
      );

      if (success) {
        // Refresh current reflection data
        String currentWeekId = WeeklyReflectionService.getCurrentWeekId();
        currentWeekReflection.value =
            await WeeklyReflectionService.getWeeklyReflection(
                firebaseUserId(), currentWeekId);

        // Check if this was the last category
        if (isLastCategory) {
          // Check if all categories are now complete
          List<String> allCategories = ReflectionCategories.categoryKeys;
          bool allCategoriesComplete = allCategories.every((category) =>
              currentWeekReflection.value!.reflections.containsKey(category));

          if (allCategoriesComplete) {
            // Completed all categories
            showToast('Weekly reflection completed! Thank you for sharing.');
            hasCompletedThisWeek.value = true;
            statusMessage.value =
                "You've completed this week's reflection. Come back next week for a new one!";
            Get.back();
          } else {
            // Move to next category (shouldn't happen on last category, but just in case)
            _moveToNextCategory();
            showToast('Answer saved! Moving to next question.');
          }
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
  static Future<bool> addStaticDemoData(String userId) async {
    try {
      List<Map<String, dynamic>> demoWeeks = [
        {
          'weekId': '2025_29',
          'startDate': DateTime(2025, 7, 14),
          'endDate': DateTime(2025, 7, 20, 23, 59, 59),
          'reflections': {
            'career': {
              'rating': 7,
              'note': 'Prepared presentation for clients'
            },
            'family': {'rating': 8, 'note': 'Celebrated birthday together'},
            'friendships': {'rating': 6, 'note': 'Missed a planned outing'},
            'health': {'rating': 7, 'note': 'Started morning jogging routine'},
            'yourself': {'rating': 7, 'note': 'Feeling balanced overall'},
            'love': {'rating': 8, 'note': 'Good communication this week'},
          }
        },
        {
          'weekId': '2025_28',
          'startDate': DateTime(2025, 7, 7),
          'endDate': DateTime(2025, 7, 13, 23, 59, 59),
          'reflections': {
            'career': {
              'rating': 8,
              'note': 'Great progress on current project'
            },
            'family': {
              'rating': 9,
              'note': 'Wonderful family dinner this week'
            },
            'friendships': {'rating': 7, 'note': 'Caught up with old friends'},
            'health': {
              'rating': 6,
              'note': 'Need to exercise more consistently'
            },
            'yourself': {
              'rating': 8,
              'note': 'Feeling confident and motivated'
            },
            'love': {'rating': 9, 'note': 'Relationship is going really well'},
          }
        },
        {
          'weekId': '2025_27',
          'startDate': DateTime(2025, 6, 30),
          'endDate': DateTime(2025, 7, 6, 23, 59, 59),
          'reflections': {
            'career': {'rating': 7, 'note': 'Some challenging deadlines'},
            'family': {'rating': 8, 'note': 'Quality time with parents'},
            'friendships': {'rating': 6, 'note': 'Busy week, less social time'},
            'health': {'rating': 8, 'note': 'Good workout routine this week'},
            'yourself': {'rating': 7, 'note': 'Working on personal growth'},
            'love': {'rating': 8, 'note': 'Date night was amazing'},
          }
        },
        {
          'weekId': '2025_26',
          'startDate': DateTime(2025, 6, 23),
          'endDate': DateTime(2025, 6, 29, 23, 59, 59),
          'reflections': {
            'career': {'rating': 9, 'note': 'Got promoted this week!'},
            'family': {
              'rating': 7,
              'note': 'Some family drama to work through'
            },
            'friendships': {'rating': 9, 'note': 'Great weekend with friends'},
            'health': {'rating': 5, 'note': 'Stressed eating this week'},
            'yourself': {'rating': 8, 'note': 'Proud of recent achievements'},
            'love': {'rating': 7, 'note': 'Planning romantic getaway'},
          }
        },
        {
          'weekId': '2025_25',
          'startDate': DateTime(2025, 6, 16),
          'endDate': DateTime(2025, 6, 22, 23, 59, 59),
          'reflections': {
            'career': {'rating': 6, 'note': 'Slow but steady progress'},
            'family': {'rating': 8, 'note': 'Nice picnic with family'},
            'friendships': {'rating': 7, 'note': 'Had fun playing games'},
            'health': {'rating': 7, 'note': 'Maintained good diet'},
            'yourself': {'rating': 6, 'note': 'Need more focus on goals'},
            'love': {'rating': 8, 'note': 'Enjoyed quality moments together'},
          }
        },
      ];

      DocumentReference userReflectionRef =
          weeklyReflectionsCollection.doc(userId);

      Map<String, dynamic> weeklyData = {};

      for (var week in demoWeeks) {
        weeklyData[week['weekId']] = {
          'startDate': Timestamp.fromDate(week['startDate']),
          'endDate': Timestamp.fromDate(week['endDate']),
          'reflections': week['reflections'],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
      }

      await userReflectionRef.set(weeklyData, SetOptions(merge: true));
      return true;
    } catch (e) {
      log('Error adding static demo data: $e');
      return false;
    }
  }

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
    required String note, // Can be empty now
  }) async {
    try {
      String currentWeekId = getCurrentWeekId();
      Map<String, DateTime> weekDates = getWeekDates();

      DocumentReference userReflectionRef =
          weeklyReflectionsCollection.doc(userId);

      // Create reflection entry - note can be empty
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

      if (reflection == null) return false;

      // Manual check for completion
      List<String> allCategories = ReflectionCategories.categoryKeys;
      return allCategories
          .every((category) => reflection.reflections.containsKey(category));
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
