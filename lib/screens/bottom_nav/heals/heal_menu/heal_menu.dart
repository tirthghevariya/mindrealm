import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/utils/app_assets.dart';
import '../../../../routers/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_size_config.dart';
import '../../../../utils/app_text.dart';

class HealMenuScreen extends StatelessWidget {
  HealMenuScreen({super.key});

  final List<_HealMenuItem> items = [
    _HealMenuItem(title: AppText.soundHealing, image: AppImages.sound),
    _HealMenuItem(title: AppText.guidedMeditation, image: AppImages.meditation),
    _HealMenuItem(title: AppText.journaling, image: AppImages.journaling),
    _HealMenuItem(
        title: AppText.motivationalSpeech, image: AppImages.motivational),
    _HealMenuItem(title: AppText.affirmations, image: AppImages.affirmoti),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9, top: 20),
                  child: Text(
                    AppText.chooseYourSession,
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textBrown,
                        height: 1),
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Get.toNamed(Routes.SoundHealing);
                        },
                        child: _buildCard(items[0])),
                    InkWell(
                        onTap: () {
                          Get.toNamed(Routes.GuidedMeditation);
                        },
                        child: _buildCard(items[1])),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.getHeight(10),
                ),
                InkWell(
                    onTap: () {
                      Get.toNamed(Routes.Journal);
                    },
                    child: _HorizontalbuildCard(items[2])),
                SizedBox(
                  height: SizeConfig.getHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Get.toNamed(Routes.MotivationalSpeech);
                        },
                        child: _buildCard(items[3])),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.Affirmations);
                      },
                      child: _buildCard(items[4]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(_HealMenuItem item) {
    return Container(
      height: SizeConfig.getWidth(191),
      width: SizeConfig.getWidth(173),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(item.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(item.image), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(16),
            boxShadow: []),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 8),
          child: Text(
            item.title,
            style: GoogleFonts.openSans(
              fontSize: 32,
              color: AppColors.brown,
              fontWeight: FontWeight.bold,
              height: 1, // 👈 line spacing reduced
            ),
          ),
        ),
      ),
    );
  }

  Widget _HorizontalbuildCard(_HealMenuItem item) {
    return Container(
      height: SizeConfig.getWidth(191),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        // color: Colors.white, // <-- White background
        image:
            DecorationImage(image: AssetImage(item.image), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300, // <-- Thin frame
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32, left: 22),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            item.title,
            style: GoogleFonts.openSans(
              fontSize: 32,
              color: AppColors.brown,
              fontWeight: FontWeight.bold,
              height: 1, // 👈 line spacing reduced
            ),
          ),
        ),
      ),
    );
  }
}

class _HealMenuItem {
  final String title;
  final String image;

  const _HealMenuItem({
    required this.title,
    required this.image,
  });
}
