// main.dart (or your root navigation screen)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/controllers/bottom_nev_controller.dart';

import 'package:mindrealm/screens/bottom_nav/reflection/reflection.dart';

import 'package:mindrealm/screens/bottom_nav/widgets/CustomBottomNavBar.dart';

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

class BottomNavBar extends GetView<BottomNevController> {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: controller.screens[controller.selectedIndex.value],
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: controller.selectedIndex.value,
          onItemTapped: controller.onItemTapped,
        ),
      ),
    );
  }
}
