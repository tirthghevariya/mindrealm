import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/goal_controller.dart';
import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';

class GoalsMenuScreen extends GetView<GoalController> {
  const GoalsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              AppImages.goalsMenuBg,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Left Side
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.getHeight(60),
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Text(
                            AppText.reachYourGoals,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 40,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(16)),

                          /// Slideshow Container
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.GoalsOverviewScreen);
                            },
                            child: Container(
                              height: SizeConfig.getHeight(290),
                              width: SizeConfig.getWidth(175),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.transparent,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Obx(
                                    () => controller.slideshowImages.isNotEmpty
                                        ? CarouselSlider.builder(
                                            itemCount: controller
                                                .slideshowImages.length,
                                            options: CarouselOptions(
                                              height: double
                                                  .infinity, // Fills container
                                              viewportFraction:
                                                  1.0, // Full width
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  const Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 800),
                                              enableInfiniteScroll: true,
                                              onPageChanged:
                                                  controller.onSlideChanged,
                                            ),
                                            itemBuilder:
                                                (context, index, realIndex) {
                                              final imageUrl = controller
                                                  .slideshowImages[index];
                                              return imageUrl.startsWith("http")
                                                  ? CachedNetworkImage(
                                                      imageUrl: imageUrl,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white
                                                              .withValues(
                                                                  alpha: 0.5),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    )
                                                  : Image.asset(
                                                      imageUrl,
                                                      fit: BoxFit.cover,
                                                    );
                                            },
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.photo,
                                              size: 48,
                                              color: Colors.white
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                  ),
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.4),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black.withValues(alpha: 0.4),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.getHeight(14),
                                          horizontal: SizeConfig.getHeight(36),
                                        ),
                                        child: Text(
                                          AppText.overview,
                                          style: GoogleFonts.dmSerifDisplay(
                                            fontSize: 40,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(10)),
                        ],
                      ),
                    ),
                  ),

                  /// Right Side
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: SizeConfig.getHeight(30)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (var label in [
                            AppText.yourself,
                            AppText.health,
                            AppText.love,
                            AppText.career,
                            AppText.family,
                            AppText.friendships,
                          ])
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.getWidth(10)),
                              child: InkWell(
                                onTap: () {
                                  int tabIndex = [
                                    AppText.yourself,
                                    AppText.health,
                                    AppText.love,
                                    AppText.career,
                                    AppText.family,
                                    AppText.friendships,
                                  ].indexOf(label);

                                  Get.toNamed(Routes.goalDetailScreen,
                                      arguments: {"tabIndex": tabIndex});
                                },
                                child: Container(
                                  width: SizeConfig.getWidth(157),
                                  height: SizeConfig.getHeight(105),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: SizeConfig.getWidth(16),
                                      left: SizeConfig.getWidth(12),
                                    ),
                                    child: Text(
                                      label,
                                      style: GoogleFonts.openSans(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.brown,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
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
