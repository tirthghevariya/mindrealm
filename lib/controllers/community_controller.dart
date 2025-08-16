import 'dart:developer';

import 'package:get/get.dart';
import 'package:mindrealm/models/community_model.dart';
import 'package:mindrealm/utils/collection.dart';

class CommunityController extends GetxController {
  Rx<CommunityModel?> communityModel = Rx<CommunityModel?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchCommunity();
  }

  Future<void> fetchCommunity() async {
    try {
      final snapshot = await communityCollection
          .doc('wXULxPzKupaok12qCKvL') // change doc ID as needed
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          communityModel.value = CommunityModel.fromMap(data);
        }
      }
    } catch (e) {
      log("Error fetching community: $e");
    }
  }
}
