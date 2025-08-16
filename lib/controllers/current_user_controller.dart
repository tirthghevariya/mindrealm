import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mindrealm/models/user_model.dart';
import 'package:mindrealm/routers/app_routes.dart';
import 'package:mindrealm/utils/collection.dart';

class CurrentUserController extends GetxController {
  // User data
  final userProfile = Rx<UserProfileModel?>(null);

  // Fetch user profile from Firestore
  Future<void> getUserProfile({bool isRoute = false}) async {
    try {
      if (firebaseUserId().isEmpty) {
        Get.offAllNamed(Routes.loginScreen);
        return;
      }
      DocumentSnapshot doc = await usersCollection.doc(firebaseUserId()).get();

      if (doc.exists) {
        userProfile.value = UserProfileModel.fromFirestore(doc);
        if (isRoute) {
          Get.offAllNamed(Routes.bottomNavBar);
        }
      } else {
        Get.offAllNamed(Routes.loginScreen);
      }
    } catch (e) {
      // log('Error fetching user profile: $e');
    }
  }
}
