import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/routers/app_routes.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/gratitude.dart';
import 'package:mindrealm/utils/app_size_config.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_text.dart';
import '../bottom_nav.dart';

class DailyGratitude extends StatefulWidget {
  const DailyGratitude({super.key});

  @override
  State<DailyGratitude> createState() => _DailyGratitudeState();
}

class _DailyGratitudeState extends State<DailyGratitude> {
  int _currentStep = 0;

  final List<Widget> _screens = const [
    Gratitude(),
  ];

  void _nextStep() {
    if (_currentStep < _screens.length - 1) {
      setState(() => _currentStep++);
    } else {
      Get.offAllNamed(Routes.bottomNavBar, arguments: {"tabIndex": 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.brown,
                      size: 32,
                    ))
              ],
            ),
          ),
          SizedBox(height: SizeConfig.getHeight(50)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(64)),
            child: Column(
              children: [
                _screens[_currentStep],
                SizedBox(
                  height: SizeConfig.getWidth(40),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Border radius only
                      ),
                    ),
                    onPressed: () {
                      // Handle next
                      _nextStep();
                    },
                    child: Text(
                      AppText.continueTextDone,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
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
