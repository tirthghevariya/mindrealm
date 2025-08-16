import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mindrealm/controllers/reflection_controllers/weekly_reflection_controller.dart';
import 'package:mindrealm/models/daily_reflection_model.dart';
import 'package:mindrealm/models/weekly_reflection_model.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/common_loader.dart';
import 'package:mindrealm/widgets/common_tost.dart';

class WellBeingOverviewController extends GetxController {
  RxList<DailyReflectionEntry?> dailyReflectionData =
      <DailyReflectionEntry>[].obs;
  RxList<DailyReflectionEntry?> last30DaysdailyReflectionData =
      <DailyReflectionEntry>[].obs;

  // Existing properties...
  RxList<WeeklyReflectionDocument> weeklyReflectionData =
      <WeeklyReflectionDocument>[].obs;
  RxBool isLoadingWeeklyData = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      CommonLoader.showLoader();
      await getUserDailyReflection();
      await loadWeeklyReflectionData();
      CommonLoader.hideLoader();
    });
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

        last30DaysdailyReflectionData.value = dailyReflectionData
            .where((e) => e!.datetime
                .isAfter(DateTime.now().subtract(Duration(days: 30))))
            .toList()
            .reversed
            .toList();
      } else {
        log("No reflection document found for user.");
      }
    } catch (e) {
      log('Error fetching daily reflection: $e');
    }
  }

// Load weekly reflection data
  Future<void> loadWeeklyReflectionData() async {
    isLoadingWeeklyData.value = true;

    try {
      List<WeeklyReflectionDocument> data =
          await WeeklyReflectionService.getUserReflectionHistory(
              firebaseUserId());
      weeklyReflectionData.value = data;
    } catch (e) {
      print('Error loading weekly reflection data: $e');

      showToast("Failed to load weekly reflection data", err: true);
    } finally {
      isLoadingWeeklyData.value = false;
    }
  }

  // Get current month's weekly reflection data
  List<WeeklyReflectionDocument> getCurrentMonthWeeklyData() {
    DateTime now = DateTime.now();
    String currentMonthYear =
        '${now.year}_${now.month.toString().padLeft(2, '0')}';

    return weeklyReflectionData.where((reflection) {
      // Extract year and month from weekId (format: 2025_33)
      List<String> parts = reflection.yearWeek.split('_');
      if (parts.length >= 2) {
        int year = int.tryParse(parts[0]) ?? 0;
        int weekNumber = int.tryParse(parts[1]) ?? 0;

        // Convert week number to approximate month
        DateTime weekDate = getDateFromWeekNumber(year, weekNumber);
        String weekMonthYear =
            '${weekDate.year}_${weekDate.month.toString().padLeft(2, '0')}';

        return weekMonthYear == currentMonthYear;
      }
      return false;
    }).toList();
  }

  // Get average scores by category from weekly data
  Map<String, double> getAverageScoresByCategory(
      List<WeeklyReflectionDocument> weeklyData) {
    Map<String, List<double>> categoryScores = {
      'health': [],
      'love': [],
      'family': [],
      'career': [],
      'friendships': [],
      'yourself': [],
    };

    // Collect all scores for each category
    for (WeeklyReflectionDocument week in weeklyData) {
      if (week.isComplete) {
        week.reflections.forEach((category, entry) {
          if (categoryScores.containsKey(category)) {
            categoryScores[category]!.add(entry.rating.toDouble());
          }
        });
      }
    }

    // Calculate averages
    Map<String, double> averages = {};
    categoryScores.forEach((category, scores) {
      if (scores.isNotEmpty) {
        double average = scores.reduce((a, b) => a + b) / scores.length;
        averages[category] = double.parse(average.toStringAsFixed(1));
      } else {
        averages[category] = 0.0;
      }
    });

    return averages;
  }

  // Get weekly data for the last N weeks
  List<WeeklyReflectionDocument> getLastNWeeksData(int numberOfWeeks) {
    List<WeeklyReflectionDocument> sortedData = List.from(weeklyReflectionData);
    sortedData.sort((a, b) {
      // Sort by yearWeek descending (most recent first)
      return b.yearWeek.compareTo(a.yearWeek);
    });

    return sortedData.take(numberOfWeeks).toList();
  }

  // Get category trend data for line chart
  Map<String, List<double>> getCategoryTrendData(int numberOfWeeks) {
    List<WeeklyReflectionDocument> recentWeeks =
        getLastNWeeksData(numberOfWeeks);
    recentWeeks = recentWeeks.reversed.toList(); // Oldest first for trend

    Map<String, List<double>> trendData = {
      'health': [],
      'love': [],
      'family': [],
      'career': [],
      'friendships': [],
      'yourself': [],
    };

    for (WeeklyReflectionDocument week in recentWeeks) {
      // Add scores for each category, or 0 if not available
      trendData.forEach((category, scores) {
        if (week.reflections.containsKey(category)) {
          scores.add(week.reflections[category]!.rating.toDouble());
        } else {
          scores.add(0.0); // Default value if category not found
        }
      });
    }

    return trendData;
  }

  // Helper method to convert week number to approximate date
  DateTime getDateFromWeekNumber(int year, int weekNumber) {
    DateTime jan1 = DateTime(year, 1, 1);
    int daysToAdd = (weekNumber - 1) * 7;
    return jan1.add(Duration(days: daysToAdd));
  }

  // Get weekly completion rate
  double getWeeklyCompletionRate() {
    if (weeklyReflectionData.isEmpty) return 0.0;

    int completedWeeks =
        weeklyReflectionData.where((week) => week.isComplete).length;
    return completedWeeks / weeklyReflectionData.length;
  }

  // Get category with highest average score
  String getBestPerformingCategory() {
    Map<String, double> averages =
        getAverageScoresByCategory(weeklyReflectionData);

    if (averages.isEmpty) return 'No data';

    String bestCategory = '';
    double highestScore = 0.0;

    averages.forEach((category, score) {
      if (score > highestScore) {
        highestScore = score;
        bestCategory = category;
      }
    });

    return bestCategory.isEmpty ? 'No data' : _formatCategoryName(bestCategory);
  }

  // Get category with lowest average score (needs improvement)
  String getCategoryNeedingImprovement() {
    Map<String, double> averages =
        getAverageScoresByCategory(weeklyReflectionData);

    if (averages.isEmpty) return 'No data';

    String worstCategory = '';
    double lowestScore = 11.0; // Higher than max possible score

    averages.forEach((category, score) {
      if (score > 0 && score < lowestScore) {
        lowestScore = score;
        worstCategory = category;
      }
    });

    return worstCategory.isEmpty
        ? 'No data'
        : _formatCategoryName(worstCategory);
  }

  // Format category name for display
  String _formatCategoryName(String category) {
    switch (category) {
      case 'health':
        return 'Health';
      case 'love':
        return 'Love Life';
      case 'family':
        return 'Family';
      case 'career':
        return 'Career';
      case 'friendships':
        return 'Friendships';
      case 'yourself':
        return 'Self';
      default:
        return category.replaceFirst(category[0], category[0].toUpperCase());
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await loadWeeklyReflectionData();
  }
}
