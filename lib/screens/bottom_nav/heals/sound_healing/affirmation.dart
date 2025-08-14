import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/screens/bottom_nav/heals/sound_healing/widgets/audiowave.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/daily_reflection/daily_reflection_flow_screen.dart';
import 'package:mindrealm/utils/app_sounds.dart';
import 'package:mindrealm/utils/app_style.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_size_config.dart';
import '../../../../utils/app_text.dart';
import '../../community/community.dart';
import '../../goals_screen/goals_screen.dart';
import '../../home/home_screen.dart';
import '../../reflection/reflection.dart';
import '../../widgets/CustomBottomNavBar.dart';

class Affirmations extends StatefulWidget {
  const Affirmations({super.key});

  @override
  State<Affirmations> createState() => _AffirmationsState();
}

class _AffirmationsState extends State<Affirmations> {
  int _selectedIndex = 3;

  final List<Widget> _screens = [
    const HomeScreen(),
    ReflectionOptionsScreen(),
    const GoalsMenuScreen(),
    affirmationBodyData(),
    Community(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

Widget affirmationBodyData() {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(11),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: AppColors.brown,
                  ),
                )),
            SizedBox(
              height: SizeConfig.getHeight(58),
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    AppText.affirmation,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.getHeight(108),
                  ),
                  SizedBox(
                      height: 200,
                      child: AudioPlayerWaveUI(
                        assetSong: AppSounds.affirmationsSound,
                      )),
                  SizedBox(
                    height: SizeConfig.getHeight(60),
                  ),
                  SizedBox(
                    width: SizeConfig.getHeight(280),
                    child: Text(
                      AppText.rewiringYourThoughtWithAffirmation,
                      textAlign: TextAlign.center,
                      style: AppStyle.textStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
