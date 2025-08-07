import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_style.dart';
import '../../../utils/app_text.dart';

class WellBeingOverview extends StatelessWidget {
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
                            Container(
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
                            color: Colors.white.withOpacity(0.95),
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
                                child: LineChart(
                                  LineChartData(
                                    minY: 0,
                                    maxY: 10,
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 2,
                                          reservedSize: 28,
                                          getTitlesWidget: (value, meta) =>
                                              Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 1,
                                          getTitlesWidget: (value, meta) {
                                            const labels = [
                                              'Nov 23',
                                              '24',
                                              '25',
                                              '26',
                                              '27',
                                              '28',
                                              '29',
                                              '30'
                                            ];
                                            if (value >= 0 &&
                                                value < labels.length) {
                                              return Text(
                                                labels[value.toInt()],
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.grey,
                                                ),
                                              );
                                            }
                                            return SizedBox.shrink();
                                          },
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                    gridData: FlGridData(show: false),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        isCurved: true,
                                        barWidth: 3,
                                        color: AppColors.primary,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: AppColors.primary
                                              .withOpacity(0.3),
                                        ),
                                        dotData: FlDotData(
                                          show: true,
                                          checkToShowDot: (spot, _) =>
                                              spot.x == 7,
                                          // Show only for last point
                                          getDotPainter:
                                              (spot, percent, barData, index) =>
                                                  FlDotCirclePainter(
                                            radius: 4,
                                            color: AppColors.primary,
                                            strokeWidth: 2,
                                            strokeColor: Colors.white,
                                          ),
                                        ),
                                        spots: const [
                                          FlSpot(0, 1),
                                          FlSpot(1, 2),
                                          FlSpot(2, 2.2),
                                          FlSpot(3, 3.5),
                                          FlSpot(4, 5.5),
                                          FlSpot(5, 4.8),
                                          FlSpot(6, 6.8),
                                          FlSpot(7, 9.5),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(60)),

                        Container(
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
                        Container(
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
                                      Container(
                                        width: SizeConfig.screenWidth * .6,
                                        height: SizeConfig.screenHeight * .65,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 35,
                                              top: 35), // Reduced left padding
                                          child: GridView.builder(
                                            itemCount: 30,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 4,
                                              crossAxisSpacing:
                                                  60, // More spacing between columns
                                              mainAxisSpacing:
                                                  16, // More spacing between rows
                                            ),
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  // Get.toNamed(
                                                  //     Routes.DailyGratitude);
                                                },
                                                child: Text(
                                                  "Gratitude",
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: SizeConfig.getWidth(10)),
                                        child: RotatedBox(
                                            quarterTurns: -45,
                                            child: Center(
                                              child: Text(AppText.share,
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors.brown)),
                                            )),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 27, bottom: 27),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        AppText.allCounts,
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.dmSerifDisplay(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.brown,
                                          height: 1, // reduced line height
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
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

class CategoryLineChart extends StatelessWidget {
  const CategoryLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.getWidth(360),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
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
                    color: Colors.grey.withOpacity(0.2),
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
                  // bottomTitles: AxisTitles(
                  //   sideTitles: SideTitles(
                  //     showTitles: true,
                  //     getTitlesWidget: (value, _) => const Text(
                  //       "Month",
                  //       style: TextStyle(fontSize: 12, color: Colors.grey),
                  //     ),
                  //   ),
                  // ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        // Define month labels based on the index
                        const months = ['Jun', 'Jul', 'Aug', 'Sept'];

                        // Round the value to index
                        final index = value.toInt();

                        if (index >= 0 && index < months.length) {
                          return Text(
                            months[index],
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          );
                        } else {
                          return const SizedBox
                              .shrink(); // empty for invalid indexes
                        }
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  _makeLine([
                    2,
                    3,
                    3,
                    6,
                  ], AppColors.brown, "Love"),
                  _makeLine([
                    4,
                    4,
                    5,
                    5,
                  ], AppColors.primary, "Family"),
                  _makeLine([
                    4,
                    5,
                    6,
                    7,
                  ], AppColors.textYellow, "Career"),
                  _makeLine([10, 8, 8, 9], AppColors.grey, "Friends"),
                  _makeLine([
                    5,
                    6,
                    6,
                    7,
                  ], AppColors.green, "Self"),
                  _makeLine([4, 8, 6, 8], AppColors.textPurple, "Health"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _makeLine(List<double> values, Color color, String label) {
    return LineChartBarData(
      spots:
          List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i])),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(show: true),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendItem(Colors.brown, 'Love'),
        _legendItem(Colors.orange, 'Family'),
        _legendItem(Colors.blue, 'Friends'),
        _legendItem(Colors.yellow, 'Career'),
        _legendItem(Colors.green, 'Self'),
        _legendItem(Colors.purple, 'Health'),
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

class LifeScoreBarChart extends StatelessWidget {
  const LifeScoreBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 356,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: BarChart(
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
                  return Text(
                    labels[value.toInt()],
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeBar(0, 8),
            _makeBar(1, 6),
            _makeBar(2, 10),
            _makeBar(3, 8),
            _makeBar(4, 5),
            _makeBar(5, 7),
          ],
        ),
      ),
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
