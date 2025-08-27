import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/controllers/home_controller.dart';
import 'package:mindrealm/widgets/common_tost.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';

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
            top: statusBarSize + Get.width * 0.02,
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
                    "- ${controller.todayQuote.value?.by ?? ""}",
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
                  onPressed: () async {
                    const message = "Hello from Flutter 🚀 #flutter";

                    await Clipboard.setData(const ClipboardData(text: message));

                    final Uri uri = Uri.parse(
                        "https://www.instagram.com//send?text=gahjdgakshg");
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
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
                  onPressed: () async {
                    // Copy message to clipboard
                    await Clipboard.setData(ClipboardData(
                        text:
                            "${controller.todayQuote.value?.quote ?? ""} - ${controller.todayQuote.value?.by ?? ""}"));

                    // Open TikTok app
                    final Uri tiktok = Uri.parse("snssdk1233://");
                    if (await canLaunchUrl(tiktok)) {
                      await launchUrl(tiktok,
                          mode: LaunchMode.externalApplication);
                      debugPrint(
                          "TikTok opened. Message copied, user can paste in DM.");
                    } else {
                      showToast("TikTok not installed!", err: true);
                    }
                  },
                  icon: SvgPicture.asset(
                    AppImages.tiktokIcon,
                    width: 32,
                    height: 32,
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: () async {
                    final Uri fbUri = Uri.parse(
                        "https://www.facebook.com/sharer/sharer.php?u=${controller.todayQuote.value?.quote ?? ""} - ${controller.todayQuote.value?.by ?? ""}");

                    await launchUrl(fbUri,
                        mode: LaunchMode.externalApplication);
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
