import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';

class GoalsOverviewScreen extends StatefulWidget {
  const GoalsOverviewScreen({super.key});

  @override
  State<GoalsOverviewScreen> createState() => _GoalsOverviewScreenState();
}

class _GoalsOverviewScreenState extends State<GoalsOverviewScreen> {
  // Dummy goal data from each category (Replace with actual shared state or DB)
  final List<String> goalTitles = [
    AppText.goalForYourself,
    AppText.goalForHealth,
    AppText.goalForLove,
    AppText.goalForCareer,
    AppText.goalForFamily,
    AppText.goalForFriendships,
  ];

  // This list should ideally be filled with user goal text
  final List<String> goalDescriptions = [
    "Become more confident.",
    "Maintain a healthy lifestyle.",
    "Build meaningful relationships.",
    "Advance in my career.",
    "Spend quality time with family.",
    "Support and grow friendships.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: AppColors.white.withValues(alpha: 0.8),
        height: SizeConfig.getHeight(70),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: AppColors.brown),
            Icon(Icons.favorite, color: AppColors.brown),
            Icon(Icons.person, color: AppColors.brown),
          ],
        ),
      ),
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              AppImages.goalsOverviewBg,
              fit: BoxFit.cover,
            ),
          ),

          /// Foreground Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: SizeConfig.getHeight(90)), // space for nav bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.getHeight(24)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: AppColors.brown, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: SizeConfig.getHeight(12)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getWidth(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.goalOverview,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 36,
                            fontStyle: FontStyle.italic,
                            color: AppColors.brown,
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(24)),

                        /// List of Category Goal Boxes
                        for (int i = 0; i < goalTitles.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.goalDetailScreen,
                                    arguments: {'tabIndex': i});
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                // height: SizeConfig.getHeight(110),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.25),
                                      blurRadius: 2.4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goalTitles[i],
                                      maxLines: 1,
                                      style: GoogleFonts.openSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.brown,
                                      ),
                                    ),
                                    // SizedBox(height: 2),
                                    Text(
                                      goalDescriptions[i],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: AppColors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
