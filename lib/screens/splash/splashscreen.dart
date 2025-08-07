import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/screens/auth/page/login_screen.dart';
import 'package:mindrealm/utils/app_text.dart';
import '../../routers/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_size_config.dart';
import '../../utils/app_style.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  // double _splashOpacity = 1.0;
  // bool _hideSplash = false;

  @override
  void initState() {
    super.initState();

    // // Start fade after short delay
    // Future.delayed(const Duration(milliseconds: 1), () {
    //   setState(() {
    //     _splashOpacity = 0.0;
    //   });
    // });

    // After delay, check if user is logged in
    Future.delayed(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Navigate to home if logged in
        Get.offAllNamed(Routes.BottomNavBar);
      } else {
        Get.offAllNamed(Routes.login);
        // Else show login
        // setState(() {
        //   _hideSplash = true;
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // if (_hideSplash) ,
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppImages.background,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.6,
                      child: Image.asset(AppImages.logo),
                    ),
                    Text(
                      AppText.keepBalance,
                      textAlign: TextAlign.center,
                      style: AppStyle.textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
