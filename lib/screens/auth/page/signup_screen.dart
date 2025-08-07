import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_style.dart';
import '../../../utils/app_text.dart';
import '../widgets/custom_textfield.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppImages.bgLogin,
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          Positioned.fill(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getWidth(24),
                  vertical: SizeConfig.getHeight(32),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    SizedBox(
                      width: SizeConfig.getWidth(217),
                      child: Image.asset(
                        AppImages.logo,
                        color: AppColors.primary,
                      ),
                    ),

                    // Create Account Title
                    Text(
                      AppText.createAccount,
                      style: AppStyle.textStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brown,
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(6)),

                    // Subtitle
                    Text(
                      AppText.enterEmailForSignup,
                      style: AppStyle.textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.brown,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: SizeConfig.getHeight(24)),

                    // Email Input
                    SizedBox(
                      height: SizeConfig.getHeight(48),
                      child: const CustomTextField(
                        hint: 'email@domain.com',
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(24)),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: SizeConfig.getHeight(48),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.QuoteScreen);
                        },
                        child: Text(
                          AppText.continueText,
                          style: AppStyle.textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(16)),

                    // Divider Text
                    Text(
                      AppText.or,
                      style: AppStyle.textStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.brown,
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(16)),

                    SizedBox(height: SizeConfig.getHeight(24)),

                    // Terms & Policy Text
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppText.byClickContinue,
                        style: AppStyle.textStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: AppText.termsOfService,
                            style: AppStyle.textStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                          TextSpan(
                            text: AppText.and,
                            style: AppStyle.textStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey,
                            ),
                          ),
                          TextSpan(
                            text: AppText.privacyPolicy,
                            style: AppStyle.textStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
