import 'package:get/get.dart';
import 'package:mindrealm/controllers/current_user_controller.dart';
import 'package:mindrealm/controllers/goal_detail_controller.dart';
import 'package:mindrealm/controllers/splash_controller.dart';
import 'package:mindrealm/service/goal_image_service.dart';

import '../controllers/auth_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}

class GoalDetailBunding extends Bindings {
  @override
  void dependencies() {
    Get.put(GoalDetailController());
    Get.put(UserGoalService());
  }
}
