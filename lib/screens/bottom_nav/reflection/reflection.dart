import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';

class ReflectionOptionsScreen extends StatelessWidget {
  const ReflectionOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(24)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.getHeight(16)),

                // Title
                Text(
                  AppText.whatAreYouUpToTitle,
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 32,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(24)),

                // Daily Reflection Button
                _OptionCard(
                  imagePath: AppImages.reflaction1,
                  label: AppText.dailyReflection,
                  onTap: () {
                    Get.toNamed(Routes.ReflectionFlowScreen);
                    // Navigate to Daily Reflection
                  },
                  color: AppColors.brown,
                ),
                SizedBox(height: SizeConfig.getHeight(16)),

                // Weekly Reflection Button
                _OptionCard(
                  imagePath: AppImages.reflaction2,
                  label: AppText.weeklyReflection,
                  onTap: () {
                    Get.toNamed(Routes.WeeklyReflection);
                  },
                ),
                SizedBox(height: SizeConfig.getHeight(16)),

                // Wellbeing Overview Button
               _OptionCard(
                  imagePath: AppImages.reflaction3,
                  label: AppText.wellbeingOvervi,
                  onTap: () {
                    Get.toNamed(Routes.WellBeingOverview);
                  },
                ),
                SizedBox(height: SizeConfig.getHeight(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  final Color color;

  _OptionCard({
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              imagePath,
              height: SizeConfig.getWidth(160),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: SizeConfig.getWidth(160),
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getHeight(22),
                  vertical: SizeConfig.getHeight(12)),
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: color,
                  height: 0.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
