import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/home_controller.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';

class QuoteScreen extends GetView<HomeController> {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppImages.bgQuote,
              fit: BoxFit.cover,
            ),
          ),

          // Back button
          Positioned(
            top: 32,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: AppColors.brown,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await controller.shareQuote();
                  },
                  icon: Icon(
                    Icons.share,
                    size: 32,
                    color: AppColors.brown,
                  ),
                ),
              ],
            ),
          ),

          // Center Content
          Center(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  SizedBox(
                    width: SizeConfig.getWidth(150),
                    child: Image.asset(
                      AppImages.logo,
                      color: AppColors.brown,
                    ),
                  ),

                  SizedBox(height: SizeConfig.getHeight(32)),

                  // Quote Text
                  SizedBox(
                    width: SizeConfig.getWidth(247),
                    child: Text(
                      controller.todayQuote.value?.quote ?? "",
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        color: AppColors.brown,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: SizeConfig.getHeight(24)),

                  // Author
                  Text(
                    "- ${controller.todayQuote.value?.by}" ?? "",
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Add Instagram share logic
                  },
                  icon: SvgPicture.asset(
                    AppImages
                        .instagramIcon, // e.g., 'assets/icons/instagram.svg'
                    width: 32,
                    height: 32,
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    // TODO: Add TikTok share logic
                  },
                  icon: SvgPicture.asset(
                    AppImages.tiktokIcon,
                    width: 32,
                    height: 32,
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    // TODO: Add Facebook share logic
                  },
                  icon: SvgPicture.asset(
                    AppImages.facebookIcon,
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
