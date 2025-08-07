import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindrealm/utils/app_text.dart';
import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_style.dart';
import '../widgets/custom_textfield.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Email/Password login
  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        Get.offAllNamed(Routes.BottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = 'Login failed. Please try again';
      }
      Get.snackbar(
        'Login Error',
        message,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      if (kIsWeb) {
        // ✅ Web Google Sign-In using Popup
        GoogleAuthProvider authProvider = GoogleAuthProvider();

        final userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);

        if (userCredential.user != null) {
          Get.offAllNamed(Routes.BottomNavBar);
        }
      } else {
        // ✅ Mobile Google Sign-In (requires google_sign_in package)
        final GoogleSignIn signIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await signIn.signIn();
        if (googleUser == null) {
          setState(() => _isLoading = false);
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          Get.offAllNamed(Routes.BottomNavBar);
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Google Sign-In Failed',
        e.message ?? 'An error occurred',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Google',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppImages.bgLogin,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.9),
            ),
          ),

          // Foreground Content
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getWidth(24),
                    vertical: SizeConfig.getHeight(20),
                  ),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Spacer(flex: 1),

                            // Logo
                            Semantics(
                              image: true,
                              label: 'App Logo',
                              child: SizedBox(
                                width: SizeConfig.getWidth(217),
                                child: Image.asset(
                                  AppImages.logo,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                            // Welcome Text
                            Semantics(
                              header: true,
                              child: Text(
                                AppText.welcome,
                                style: AppStyle.textStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brown,
                                ),
                              ),
                            ),

                            SizedBox(height: SizeConfig.getHeight(39)),

                            // Input Fields
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.getHeight(24)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: SizeConfig.getHeight(60),
                                    child: CustomTextField(
                                      controller: _emailController,
                                      hint: 'email@domain.com',
                                      keyboardType: TextInputType.emailAddress,
                                      validator: _validateEmail,
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.getHeight(24)),
                                  SizedBox(
                                    height: SizeConfig.getHeight(60),
                                    child: CustomTextField(
                                      controller: _passwordController,
                                      hint: 'password',
                                      isPassword: true,
                                      showToggle: true,
                                      validator: _validatePassword,
                                      autofillHints: const [
                                        AutofillHints.password
                                      ],
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) =>
                                          _loginWithEmail(),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed:
                                          _isLoading ? null : _loginWithEmail,
                                      child: _isLoading
                                          ? const CircularProgressIndicator(
                                              color: AppColors.white,
                                            )
                                          : Text(
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
                                      onPressed:
                                          _isLoading ? null : _signInWithGoogle,
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: AppColors.white,
                                        side: BorderSide(
                                            color: AppColors.grey
                                                .withValues(alpha: 0.3)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                        onPressed: _isLoading
                                            ? null
                                            : () {
                                              },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: AppColors.white,
                                          side: BorderSide(
                                              color: AppColors.grey
                                                  .withValues(alpha: 0.3)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                      },
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
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                      },
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(flex: 2),

                            // Create account link
                            InkWell(
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      Get.toNamed(Routes.SignupScreenDup);
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
