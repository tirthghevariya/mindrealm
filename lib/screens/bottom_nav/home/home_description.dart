import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_assets.dart'; // Make sure to define `aboutBgImage` here
import '../../../utils/app_text.dart';  // Add your text constants here

class AboutMindRealmScreen extends StatelessWidget {
  const AboutMindRealmScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              AppImages.descriptionbg, // ← Add this to AppImages
              fit: BoxFit.cover,
            ),
          ),

          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.white,size: 32,),
              ),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                right: SizeConfig.getWidth(24),
                left: SizeConfig.getWidth(24),
                top: SizeConfig.getWidth(40),
              ),
              child: Container(
                padding: EdgeInsets.all(SizeConfig.getHeight(24)),
                decoration: BoxDecoration(
                  color: AppColors.whiteAccent2,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Center(
                        child: Image.asset(AppImages.logo,color: AppColors.primary,width: SizeConfig.getWidth(174),),
                      ),

                      // Paragraphs
                      Text(
                        AppText.aboutPara1,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      SizedBox(height: SizeConfig.getHeight(16)),

                      Text(
                        AppText.aboutPara2,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.primary,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      SizedBox(height: SizeConfig.getHeight(16)),

                      Text(
                        AppText.aboutPara3,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.primary,
                            fontWeight: FontWeight.w700
                        ),
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
  }
}
