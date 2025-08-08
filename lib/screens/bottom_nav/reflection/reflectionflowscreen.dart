import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/dailygratitude.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenone.dart';
import 'package:mindrealm/utils/app_size_config.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_text.dart';

class ReflectionFlowScreen extends StatefulWidget {
  const ReflectionFlowScreen({super.key});

  @override
  State<ReflectionFlowScreen> createState() => _ReflectionFlowScreenState();
}

class _ReflectionFlowScreenState extends State<ReflectionFlowScreen> {
  int _currentStep = 0;
  bool _isValid = false;

  void _onValidStep() {
    setState(() {
      _isValid = true;
    });
  }

  void _nextStep() {
    if (_currentStep < 0) return; // guard
    // If only one step, go to gratitude directly
    Get.to(() => DailyGratitude());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      ScreenOne(onValid: _onValidStep),
      // Add more screens like Screentwo(onValid: _onValidStep) if needed
    ];

    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 24),
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
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: SizeConfig.getHeight(50)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(64)),
            child: Column(
              children: [
                _screens[_currentStep],
                SizedBox(height: SizeConfig.getHeight(30)),
                SizedBox(
                  height: SizeConfig.getWidth(40),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isValid
                          ? AppColors.brown
                          : AppColors.brown.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isValid ? _nextStep : null,
                    child: Text(
                      AppText.continueText,
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
