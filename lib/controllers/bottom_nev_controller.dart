import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/controllers/current_user_controller.dart';
import 'package:mindrealm/models/user_model.dart';
import 'package:mindrealm/screens/bottom_nav/community/community.dart';
import 'package:mindrealm/screens/bottom_nav/goals_screen/goals_screen.dart';
import 'package:mindrealm/screens/bottom_nav/heals/heal_menu/heal_menu.dart';
import 'package:mindrealm/screens/bottom_nav/home/home_screen.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/reflection_screen.dart';

class BottomNevController extends GetxController {
  RxInt selectedIndex = 0.obs;
  CurrentUserController currentUserController =
      Get.find<CurrentUserController>();
  Rx<UserProfileModel?> get userProfile => currentUserController.userProfile;
  @override
  Future<void> onInit() async {
    super.onInit();
    await currentUserController.getUserProfile();
    //  _selectedIndex = widget.initialIndex;
    if (Get.arguments != null && Get.arguments['tabIndex'] != null) {
      selectedIndex.value = Get.arguments['tabIndex'];
    }
  }

  final List<Widget> screens = [
    const HomeScreen(),
    ReflectionOptionsScreen(),
    const GoalsMenuScreen(),
    HealMenuScreen(),
    Community(),
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
