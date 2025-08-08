import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/controllers/auth_controller.dart';
import 'package:mindrealm/utils/app_text.dart';

import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_style.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

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
          key: controller.signInformKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(flex: 1),

              // Logo
              SizedBox(
                width: SizeConfig.getWidth(217),
                child: Image.asset(
                  AppImages.logo,
                  color: AppColors.primary,
                ),
              ),

              // Welcome Text
              Text(
                AppText.welcome,
                style: AppStyle.textStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brown,
                ),
              ),

              SizedBox(height: SizeConfig.getHeight(39)),

              // Input Fields
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: SizeConfig.getHeight(24)),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.getHeight(60),
                      child: CustomTextField(
                        controller: controller.emailController,
                        hint: 'email@domain.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(24)),
                    SizedBox(
                      height: SizeConfig.getHeight(60),
                      child: CustomTextField(
                        controller: controller.passwordController,
                        hint: 'password',
                        isPassword: true,
                        showToggle: true,
                        validator: controller.validatePassword,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => controller.loginWithEmail(),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(24)),

                    // Login Button
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
                        onPressed: controller.loginWithEmail,
                        child: Text(
                          AppText.login,
                          style: AppStyle.textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(26)),

                    // Divider Text
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

                    // Continue with Apple
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

              // Terms Text
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

              // Create account link
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.signUpScreen);
                },
                child: Text(
                  AppText.orCreateAnAccount,
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
