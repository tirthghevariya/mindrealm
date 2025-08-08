import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_size_config.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_style.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: -44, // Moves the logo further left
                child: RotatedBox(
                  quarterTurns: -45,
                  child: Image.asset(
                    AppImages.logo,
                    width: SizeConfig.getWidth(300), // Bigger logo
                    color: AppColors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Center(
                        child: Text(
                          AppText.Community,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 36,
                            fontStyle: FontStyle.italic,
                            color: AppColors.brown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.getWidth(180),
                          child: Text(
                            AppText.thisPageIsReferringYouTo,
                            style: AppStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.getWidth(180),
                          child: Text(
                            AppText.youCanFindCoaches,
                            style: AppStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.getWidth(180),
                          child: Text(
                            AppText.address1,
                            style: AppStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.getWidth(180),
                          child: Text(
                            AppText.address2,
                            style: AppStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.getHeight(45)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
