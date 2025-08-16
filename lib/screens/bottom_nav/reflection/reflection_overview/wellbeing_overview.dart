import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mindrealm/controllers/reflection_controllers/reflection_overview_controller.dart';
import 'package:mindrealm/models/weekly_reflection_model.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_size_config.dart';
import '../../../../utils/app_style.dart';
import '../../../../utils/app_text.dart';

class WellBeingOverview extends GetView<WellBeingOverviewController> {
  const WellBeingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppImages.wellbeingbg,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32, left: 16),
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: AppColors.brown,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getWidth(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: SizeConfig.getHeight(60)),

                        // App Logo & Title
                        Stack(
                          children: [
                            SizedBox(
                              width: SizeConfig.getWidth(247),
                              child: Text(
                                AppText.generalOverviewTitle,
                                style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.brown,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.getHeight(26)),

                        // Chart
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'What is your average level of happiness',
                                style: AppStyle.textStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brown,
                                ),
                              ),
                              SizedBox(height: 12),
                              SizedBox(
                                height: SizeConfig.getHeight(200),
                                width: double.infinity,
                                child: Obx(() {
                                  if (controller.dailyReflectionData.isEmpty) {
                                    return const Center(
                                        child: Text("No data available"));
                                  }

                                  // Sort by date ascending
                                  final sortedData = controller
                                      .dailyReflectionData
                                      .where((e) => e != null)
                                      .map((e) => e!)
                                      .toList()
                                    ..sort((a, b) =>
                                        a.datetime.compareTo(b.datetime));

                                  // Map to FlSpot
                                  final spots =
                                      sortedData.asMap().entries.map((entry) {
                                    final index = entry.key.toDouble();
                                    final scaleValue = double.tryParse(
                                            entry.value.scaleNumber) ??
                                        0;
                                    return FlSpot(index, scaleValue);
                                  }).toList();

                                  // Labels for X-axis
                                  final labels = sortedData
                                      .map((e) => DateFormat('dd MMM')
                                          .format(e.datetime))
                                      .toList();

                                  return SizedBox(
                                    height: 200,
                                    child: Row(
                                      children: [
                                        // Fixed Y-axis labels
                                        SizedBox(
                                          width: 30,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: List.generate(
                                              6, // 0 to 10 with interval 2
                                              (i) => Text(
                                                (i * 2).toString(),
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: AppColors.grey),
                                              ),
                                            ).reversed.toList(),
                                          ),
                                        ),
                                        // Scrollable X-axis + chart
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            reverse: true,
                                            child: SizedBox(
                                              width: spots.length *
                                                  60, // dynamic width
                                              child: LineChart(
                                                LineChartData(
                                                  minY: 0,
                                                  maxY: 10,
                                                  titlesData: FlTitlesData(
                                                    leftTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles:
                                                                false)), // Hide internal Y-axis
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        showTitles: true,
                                                        interval: 1,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          if (value >= 0 &&
                                                              value <
                                                                  labels
                                                                      .length) {
                                                            return Text(
                                                              labels[value
                                                                  .toInt()],
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      AppColors
                                                                          .grey),
                                                            );
                                                          }
                                                          return const SizedBox
                                                              .shrink();
                                                        },
                                                      ),
                                                    ),
                                                    rightTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false)),
                                                    topTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false)),
                                                  ),
                                                  gridData:
                                                      FlGridData(show: false),
                                                  borderData:
                                                      FlBorderData(show: false),
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      spots: spots,
                                                      isCurved: true,
                                                      barWidth: 3,
                                                      color: AppColors.primary,
                                                      belowBarData: BarAreaData(
                                                        show: true,
                                                        color: AppColors.primary
                                                            .withValues(
                                                                alpha: 0.3),
                                                      ),
                                                      dotData:
                                                          FlDotData(show: true),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                // child: LineChart(
                                //   LineChartData(
                                //     minY: 0,
                                //     maxY: 10,
                                //     titlesData: FlTitlesData(
                                //       leftTitles: AxisTitles(
                                //         sideTitles: SideTitles(
                                //           showTitles: true,
                                //           interval: 2,
                                //           reservedSize: 28,
                                //           getTitlesWidget: (value, meta) =>
                                //               Text(
                                //             value.toInt().toString(),
                                //             style: TextStyle(
                                //               fontSize: 10,
                                //               color: AppColors.grey,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       bottomTitles: AxisTitles(
                                //         sideTitles: SideTitles(
                                //           showTitles: true,
                                //           interval: 1,
                                //           getTitlesWidget: (value, meta) {
                                //             const labels = [
                                //               'Nov 23',
                                //               '24',
                                //               '25',
                                //               '26',
                                //               '27',
                                //               '28',
                                //               '29',
                                //               '30'
                                //             ];
                                //             if (value >= 0 &&
                                //                 value < labels.length) {
                                //               return Text(
                                //                 labels[value.toInt()],
                                //                 style: TextStyle(
                                //                   fontSize: 10,
                                //                   color: AppColors.grey,
                                //                 ),
                                //               );
                                //             }
                                //             return SizedBox.shrink();
                                //           },
                                //         ),
                                //       ),
                                //       rightTitles: AxisTitles(
                                //           sideTitles:
                                //               SideTitles(showTitles: false)),
                                //       topTitles: AxisTitles(
                                //           sideTitles:
                                //               SideTitles(showTitles: false)),
                                //     ),
                                //     gridData: FlGridData(show: false),
                                //     borderData: FlBorderData(show: false),
                                //     lineBarsData: [
                                //       LineChartBarData(
                                //         isCurved: true,
                                //         barWidth: 3,
                                //         color: AppColors.primary,
                                //         belowBarData: BarAreaData(
                                //           show: true,
                                //           color: AppColors.primary
                                //               .withValues(alpha: 0.3),
                                //         ),
                                //         dotData: FlDotData(
                                //           show: true,
                                //           checkToShowDot: (spot, _) =>
                                //               spot.x == 7,
                                //           // Show only for last point
                                //           getDotPainter:
                                //               (spot, percent, barData, index) =>
                                //                   FlDotCirclePainter(
                                //             radius: 4,
                                //             color: AppColors.primary,
                                //             strokeWidth: 2,
                                //             strokeColor: Colors.white,
                                //           ),
                                //         ),
                                //         spots: const [
                                //           FlSpot(0, 1),
                                //           FlSpot(1, 2),
                                //           FlSpot(2, 2.2),
                                //           FlSpot(3, 3.5),
                                //           FlSpot(4, 5.5),
                                //           FlSpot(5, 4.8),
                                //           FlSpot(6, 6.8),
                                //           FlSpot(7, 9.5),
                                //           FlSpot(7, 9.5),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(60)),

                        SizedBox(
                          width: SizeConfig.getWidth(247),
                          child: Text(
                            AppText.monthlyCategoryOverview,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: AppColors.brown,
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(26)),

                        LifeScoreBarChart(),

                        SizedBox(height: SizeConfig.getHeight(60)),
                        SizedBox(
                          width: SizeConfig.getWidth(247),
                          child: Text(
                            AppText.categoryProgress,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: AppColors.brown,
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(26)),
                        CategoryLineChart(),
                        SizedBox(height: SizeConfig.getHeight(60)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppText.gratitudeOverview,
                              style: GoogleFonts.dmSerifDisplay(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.brown,
                                  height: 1.2),
                            ),
                            // Subtitle text with fixed font + spacing
                            Flexible(
                              // makes the text wrap if needed
                              child: Text(
                                AppText.theBasisOfLifeAndTheMostImp,
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1, // reduced line height
                                  color: AppColors.brown,
                                ),
                                textAlign: TextAlign
                                    .right, // optional: aligns to the end
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.getHeight(12)),

                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteAccent2,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.screenWidth * .6,
                                      height: SizeConfig.screenHeight * .65,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16, top: 0),
                                        child: Obx(() {
                                          return GridView.builder(
                                            itemCount: controller
                                                .last30DaysdailyReflectionData
                                                .length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio: 3,
                                                    // crossAxisCount: 2,

                                                    // crossAxisSpacing: 10,
                                                    mainAxisSpacing: 8,
                                                    crossAxisSpacing: 8),
                                            itemBuilder: (context, index) {
                                              final entry = controller
                                                      .last30DaysdailyReflectionData[
                                                  index];
                                              return InkWell(
                                                onTap: () {
                                                  // Navigate to daily gratitude details
                                                  // Get.toNamed(Routes.DailyGratitude, arguments: entry);
                                                },
                                                child: Text(
                                                  entry?.feelingWord ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeConfig.getWidth(10)),
                                      child: RotatedBox(
                                        quarterTurns: -45,
                                        child: Center(
                                          child: Text(
                                            AppText.share,
                                            style: GoogleFonts.openSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.brown,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 27, bottom: 27),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Obx(() => Text(
                                          "${controller.last30DaysdailyReflectionData.length} ${AppText.allCounts}",
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.dmSerifDisplay(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.brown,
                                            height: 1,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            AppImages.logo,
                            width: SizeConfig.getWidth(216),
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LifeScoreBarChart extends GetView<WellBeingOverviewController> {
  const LifeScoreBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 356,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        if (controller.isLoadingWeeklyData.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.brown),
            ),
          );
        }

        if (controller.weeklyReflectionData.isEmpty) {
          return const Center(
            child: Text(
              "No weekly reflection data available",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.brown,
              ),
            ),
          );
        }

        // Get current month's data or latest available data
        final currentMonthData = controller.getCurrentMonthWeeklyData();
        final averageScores =
            controller.getAverageScoresByCategory(currentMonthData);

        return BarChart(
          BarChartData(
            maxY: 10,
            minY: 0,
            groupsSpace: 20,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  reservedSize: 30,
                  getTitlesWidget: (value, _) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    const labels = [
                      'Health',
                      'Love',
                      'Family',
                      'Career',
                      'Friends',
                      'Self'
                    ];
                    if (value.toInt() < labels.length) {
                      return Text(
                        labels[value.toInt()],
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.black),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              _makeBar(0, averageScores['health'] ?? 0),
              _makeBar(1, averageScores['love'] ?? 0),
              _makeBar(2, averageScores['family'] ?? 0),
              _makeBar(3, averageScores['career'] ?? 0),
              _makeBar(4, averageScores['friendships'] ?? 0),
              _makeBar(5, averageScores['yourself'] ?? 0),
            ],
          ),
        );
      }),
    );
  }

  BarChartGroupData _makeBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 20,
          borderRadius: BorderRadius.circular(4),
          color: AppColors.brown,
        ),
      ],
    );
  }
}

class CategoryLineChart extends GetView<WellBeingOverviewController> {
  const CategoryLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.getWidth(360),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        if (controller.isLoadingWeeklyData.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.brown),
            ),
          );
        }

        if (controller.weeklyReflectionData.isEmpty) {
          return const Center(
            child: Text(
              "No weekly reflection data available",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.brown,
              ),
            ),
          );
        }

        // Get trend data for last 4-8 weeks
        Map<String, List<double>> trendData =
            controller.getCategoryTrendData(6);
        List<WeeklyReflectionDocument> recentWeeks =
            controller.getLastNWeeksData(6);
        recentWeeks = recentWeeks.reversed.toList(); // Oldest first

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegend(),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 10,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        reservedSize: 30,
                        getTitlesWidget: (value, _) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.brown),
                        ),
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index >= 0 && index < recentWeeks.length) {
                            // Extract week number from yearWeek (e.g., "2025_33" -> "W33")
                            List<String> parts =
                                recentWeeks[index].yearWeek.split('_');
                            if (parts.length >= 2) {
                              return Text(
                                'W${parts[1]}',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    _makeLine(trendData['love'] ?? [], AppColors.brown, "Love"),
                    _makeLine(
                        trendData['family'] ?? [], AppColors.primary, "Family"),
                    _makeLine(trendData['career'] ?? [], AppColors.textYellow,
                        "Career"),
                    _makeLine(trendData['friendships'] ?? [], AppColors.grey,
                        "Friends"),
                    _makeLine(
                        trendData['yourself'] ?? [], AppColors.green, "Self"),
                    _makeLine(trendData['health'] ?? [], AppColors.textPurple,
                        "Health"),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  LineChartBarData _makeLine(List<double> values, Color color, String label) {
    if (values.isEmpty) {
      return LineChartBarData(
        spots: [],
        isCurved: true,
        color: color,
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: false),
        dotData: FlDotData(show: false),
      );
    }

    return LineChartBarData(
      spots:
          List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i])),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(
        show: true,
        checkToShowDot: (spot, _) => true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 3,
          color: color,
          strokeWidth: 1,
          strokeColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendItem(AppColors.brown, 'Love'),
        _legendItem(AppColors.primary, 'Family'),
        _legendItem(AppColors.grey, 'Friends'),
        _legendItem(AppColors.textYellow, 'Career'),
        _legendItem(AppColors.green, 'Self'),
        _legendItem(AppColors.textPurple, 'Health'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}
