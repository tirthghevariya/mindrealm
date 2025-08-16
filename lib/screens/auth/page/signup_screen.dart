import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/controllers/auth_controller.dart';
import 'package:mindrealm/utils/app_text.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_style.dart';
import '../widgets/custom_textfield.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.bgLogin), fit: BoxFit.fill),
        ),
        child: Form(
          key: controller.signUpformKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(flex: 1),

              // App Logo
              SizedBox(
                width: SizeConfig.getWidth(217),
                child: Image.asset(
                  AppImages.logo,
                  color: AppColors.primary,
                ),
              ),

              // Title
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

              // Input Fields
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: SizeConfig.getHeight(24)),
                child: Column(
                  children: [
                    // Email Field
                    SizedBox(
                      height: SizeConfig.getHeight(60),
                      child: CustomTextField(
                        controller: controller.signUpEmailController,
                        hint: 'Enter Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(24)),

                    // Password Field
                    SizedBox(
                      height: SizeConfig.getHeight(60),
                      child: CustomTextField(
                        controller: controller.signUpPasswordController,
                        hint: 'Enter Password',
                        isPassword: true,
                        showToggle: true,
                        validator: controller.validatePassword,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (!controller.passwordsMatch.value) {
                            controller.passwordsMatch.value = true;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(24)),

                    // Confirm Password Field
                    SizedBox(
                      height: SizeConfig.getHeight(60),
                      child: CustomTextField(
                        controller: controller.signUPConfirmPasswordController,
                        hint: 'confirm password',
                        isPassword: true,
                        showToggle: true,
                        validator: controller.validateConfirmPassword,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    if (controller.passwordsMatch.value)
                      Padding(
                        padding: EdgeInsets.only(top: SizeConfig.getHeight(8)),
                        child: Text(
                          'Passwords do not match',
                          style: AppStyle.textStyle(
                            fontSize: 12,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    SizedBox(height: SizeConfig.getHeight(24)),

                    // Sign Up Button
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
                        onPressed: controller.signUpWithEmail,
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

                    SizedBox(height: SizeConfig.getHeight(26)),

                    // Divider
                    Text(
                      AppText.or,
                      style: AppStyle.textStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.brown,
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(26)),

                    // Continue with Google
                    SizedBox(
                      width: double.infinity,
                      height: SizeConfig.getHeight(48),
                      child: OutlinedButton.icon(
                        onPressed: controller.signInWithGoogle,
                        // _isLoading ? null : _signInWithGoogle,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                              color: AppColors.grey.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Image.asset(
                          AppImages.googleLogo,
                          width: SizeConfig.getWidth(20),
                        ),
                        label: Text(
                          AppText.continueWithGoogle,
                          style: AppStyle.textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(12)),

                    // Continue with Apple (iOS only)
                    if (Platform.isIOS)
                      SizedBox(
                        width: double.infinity,
                        height: SizeConfig.getHeight(48),
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            side: BorderSide(
                                color: AppColors.grey.withValues(alpha: 0.3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Image.asset(
                            AppImages.appleLogo,
                            width: SizeConfig.getWidth(20),
                          ),
                          label: Text(
                            AppText.continueWithApple,
                            style: AppStyle.textStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.getHeight(24)),

              // Terms and Privacy
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
                      recognizer: TapGestureRecognizer()..onTap = () {},
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
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Login Link
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  AppText.loginWithAccount,
                  style: AppStyle.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brown,
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.getHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
