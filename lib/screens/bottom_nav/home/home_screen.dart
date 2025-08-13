import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/home_controller.dart';
import 'package:share_plus/share_plus.dart';
import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_style.dart';
import '../../../utils/app_text.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                AppImages.bgHome,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Get.toNamed(Routes.ProfileNotificationsScreen);
                              },
                              child: Image.asset(
                                AppImages.person,
                                width: 24,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(24)),

                    // App Logo & Title
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            AppImages.logo,
                            width: SizeConfig.getWidth(150),
                            color: AppColors.white,
                          ),
                          Positioned(
                            bottom: 6,
                            child: Text(
                              AppText.dailyQuote,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                // fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(24)),

                    // Quote Card
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.QuoteScreen);
                        },
                        child: Container(
                          height: SizeConfig.getHeight(286),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: AssetImage(
                                    AppImages.bgQuote,
                                  ),
                                  fit: BoxFit.cover)),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.getWidth(20),
                            vertical: SizeConfig.getHeight(32),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.todayQuote.value?.quote ?? "",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 30,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.brown,
                                    height: 1),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "- ${controller.todayQuote.value?.by}" ?? "",
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brown,
                                ),
                              ),
                              SizedBox(height: SizeConfig.getHeight(26)),
                              InkWell(
                                onTap: () async {
                                  await controller.shareQuote();
                                },
                                child: Text(
                                  AppText.share,
                                  style: AppStyle.textStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.brown,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.brown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(30)),

                    // Circle Section
                    Center(
                        child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.AboutMindRealmScreen);
                      },
                      child: Image.asset(
                        AppImages.circleChart,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    )),

                    SizedBox(height: SizeConfig.getHeight(30)),

                    // Learn more
                    Center(
                      child: Container(
                        width: SizeConfig.getWidth(209),
                        child: Column(
                          children: [
                            Text(
                              AppText.learnMore1,
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.AboutMindRealmScreen);
                              },
                              child: Text(
                                AppText.learnMore2,
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.white,
                                  decorationThickness: 1.2,
                                  decorationStyle: TextDecorationStyle.solid,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(30)),

                    // Overview Title
                    Container(
                      width: SizeConfig.getWidth(250),
                      child: Text(
                        AppText.generalOverviewTitle,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: AppColors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(30)),

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
                                      getTitlesWidget: (value, meta) => Text(
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
                                          .withValues(alpha: 0.3),
                                    ),
                                    dotData: FlDotData(
                                      show: true,
                                      checkToShowDot: (spot, _) =>
                                          spot.x ==
                                          7, // Show only for last point
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

                    SizedBox(height: SizeConfig.getHeight(30)),

                    // Wellbeing Button
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.WellBeingOverview);
                        },
                        child: Text(
                          AppText.wellbeingOverview,
                          style: GoogleFonts.openSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.white,
                            decorationThickness: 1.2,
                            decorationStyle: TextDecorationStyle.solid,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(30)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
