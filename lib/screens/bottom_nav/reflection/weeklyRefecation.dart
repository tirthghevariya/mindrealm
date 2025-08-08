import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/ScreenTwo.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenFive.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenFour.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenSeven.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenSix.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenthree.dart';

import 'package:mindrealm/utils/app_size_config.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_text.dart';
import '../bottom_nav.dart';

class WeeklyReflection extends StatefulWidget {
  const WeeklyReflection({super.key});

  @override
  State<WeeklyReflection> createState() => _WeeklyReflectionState();
}

class _WeeklyReflectionState extends State<WeeklyReflection> {
  int _currentStep = 0;
  final List<bool> _isStepCompleted = List.generate(6, (index) => false);

  bool get isCurrentStepValid => _isStepCompleted[_currentStep];

  void _markCurrentStepValid() {
    setState(() {
      _isStepCompleted[_currentStep] = true;
    });
  }

  Widget getCurrentScreen() {
    final screens = [
      (VoidCallback onValid) => Screentwo(onValid: onValid),
      (VoidCallback onValid) => ScreenThree(onValid: onValid),
      (VoidCallback onValid) => Screenfour(onValid: onValid),
      (VoidCallback onValid) => Screenfive(onValid: onValid),
      (VoidCallback onValid) => ScreenSix(onValid: onValid),
      (VoidCallback onValid) => ScreenSeven(onValid: onValid),
    ];
    return screens[_currentStep](_markCurrentStepValid);
  }

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Final screen reached, navigate to bottom nav index 1
      Get.offAll(() => const BottomNavBar(initialIndex: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 24),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon:
                      Icon(Icons.arrow_back, color: AppColors.brown, size: 32),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.getHeight(30)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(24)),
            child: Column(
              children: [
                getCurrentScreen(),
                SizedBox(height: SizeConfig.getHeight(70)),
                SizedBox(
                  width: double.infinity,
                  height: SizeConfig.getWidth(40),
                  child: ElevatedButton(
                    onPressed: isCurrentStepValid ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentStepValid
                          ? AppColors.brown
                          : AppColors.brown.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentStep == 5 ? "Done" : AppText.continueText,
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
