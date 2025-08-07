// main.dart (or your root navigation screen)
import 'package:flutter/material.dart';
import 'package:mindrealm/screens/bottom_nav/goals_overview/goals_overview.dart';
import 'package:mindrealm/screens/bottom_nav/heals/sound_healing/affirmation.dart';
import 'package:mindrealm/screens/bottom_nav/heals/sound_healing/guided_meditation.dart';
import 'package:mindrealm/screens/bottom_nav/heals/sound_healing/journal.dart';
import 'package:mindrealm/screens/bottom_nav/heals/sound_healing/motivationalspeech.dart';
import 'package:mindrealm/screens/bottom_nav/heals/sound_healing/sound_healing.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/reflection.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/ScreenTwo.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenFive.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenFour.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenSeven.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenSix.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenone.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/widgets/screenthree.dart';
import 'package:mindrealm/screens/bottom_nav/widgets/CustomBottomNavBar.dart';

import '../../utils/app_colors.dart';
import 'community/community.dart';
import 'goals_screen/goals_screen.dart';
import 'heals/heal_menu/heal_menu.dart';
import 'home/home_screen.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     const HomeScreen(),
//     ReflectionOptionsScreen(),
//     const GoalsMenuScreen(),
//     HealMenuScreen(),
//     Community(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: CustomBottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
class BottomNavBar extends StatefulWidget {
  final int initialIndex;

  const BottomNavBar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    ReflectionOptionsScreen(),
    const GoalsMenuScreen(),
    HealMenuScreen(),
    Community(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
