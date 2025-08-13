import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/community_controller.dart';
import 'package:mindrealm/models/community_model.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_size_config.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_style.dart';

class Community extends GetView<CommunityController> {
  const Community({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: SafeArea(
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
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
              padding: EdgeInsets.only(left: Get.width * 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    AppText.Community,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 36,
                      fontStyle: FontStyle.italic,
                      color: AppColors.brown,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: SizeConfig.getWidth(180),
                    child: Text(
                      controller.communityModel.value?.title ?? "",
                      style: AppStyle.textStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ListView.builder(
                    itemCount:
                        controller.communityModel.value?.data?.length ?? 0,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CommunityData data =
                          controller.communityModel.value!.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.type ?? "",
                              style: AppStyle.textStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              data.name ?? "",
                              style: AppStyle.textStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              data.phone ?? "",
                              style: AppStyle.textStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              data.email ?? "",
                              style: AppStyle.textStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
