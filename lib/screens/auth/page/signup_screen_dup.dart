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

class SignupScreenDup extends StatefulWidget {
  const SignupScreenDup({super.key});

  @override
  State<SignupScreenDup> createState() => _SignupScreenDupState();
}

class _SignupScreenDupState extends State<SignupScreenDup> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  bool _passwordsMatch = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _passwordsMatch = false);
      return;
    }

    setState(() {
      _isLoading = true;
      _passwordsMatch = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Send email verification
        await userCredential.user?.sendEmailVerification();
        Get.offAllNamed(Routes.BottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account already exists with this email';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        default:
          message = 'Registration failed. Please try again';
      }
      Get.snackbar(
        'Registration Error',
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

  // Future<void> _signInWithGoogle() async {
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return;
  //
  //     final GoogleSignInAuthentication googleAuth =
  //     await googleUser.authentication;
  //
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final UserCredential userCredential =
  //     await _auth.signInWithCredential(credential);
  //
  //     if (userCredential.user != null) {
  //       Get.offAllNamed(Routes.BottomNavBar);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar(
  //       'Google Sign-In Failed',
  //       e.message ?? 'An error occurred',
  //       backgroundColor: AppColors.error,
  //       colorText: AppColors.white,
  //     );
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to sign in with Google',
  //       backgroundColor: AppColors.error,
  //       colorText: AppColors.white,
  //     );
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

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

                            // App Logo
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.getHeight(24)),
                              child: Column(
                                children: [
                                  // Email Field
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

                                  // Password Field
                                  SizedBox(
                                    height: SizeConfig.getHeight(60),
                                    child: CustomTextField(
                                      controller: _passwordController,
                                      hint: 'password',
                                      isPassword: true,
                                      showToggle: true,
                                      validator: _validatePassword,
                                      autofillHints: const [
                                        AutofillHints.newPassword
                                      ],
                                      textInputAction: TextInputAction.next,
                                      onChanged: (_) {
                                        if (!_passwordsMatch) {
                                          setState(
                                              () => _passwordsMatch = true);
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.getHeight(24)),

                                  // Confirm Password Field
                                  SizedBox(
                                    height: SizeConfig.getHeight(60),
                                    child: CustomTextField(
                                      controller: _confirmPasswordController,
                                      hint: 'confirm password',
                                      isPassword: true,
                                      showToggle: true,
                                      validator: _validateConfirmPassword,
                                      autofillHints: const [
                                        AutofillHints.newPassword
                                      ],
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) =>
                                          _signUpWithEmail(),
                                    ),
                                  ),
                                  if (!_passwordsMatch)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.getHeight(8)),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed:
                                          _isLoading ? null : _signUpWithEmail,
                                      child: _isLoading
                                          ? const CircularProgressIndicator(
                                              color: AppColors.white,
                                            )
                                          : Text(
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
                                      onPressed: () {},
                                      // _isLoading ? null : _signInWithGoogle,
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: AppColors.white,
                                        side: BorderSide(
                                            color: AppColors.grey
                                                .withOpacity(0.3)),
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

                                  // Continue with Apple (iOS only)
                                  if (Theme.of(context).platform ==
                                      TargetPlatform.iOS)
                                    SizedBox(
                                      width: double.infinity,
                                      height: SizeConfig.getHeight(48),
                                      child: OutlinedButton.icon(
                                        onPressed: _isLoading
                                            ? null
                                            : () {
                                                // TODO: Implement Apple Sign In
                                              },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: AppColors.white,
                                          side: BorderSide(
                                              color: AppColors.grey
                                                  .withOpacity(0.3)),
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
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: Navigate to Terms of Service
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
                                        // TODO: Navigate to Privacy Policy
                                      },
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(flex: 2),

                            // Login Link
                            InkWell(
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      Get.toNamed(Routes.LOGIN);
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
