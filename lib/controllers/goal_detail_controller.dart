import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindrealm/controllers/current_user_controller.dart';
import 'package:mindrealm/models/gole_model.dart';
import 'package:mindrealm/models/user_model.dart';
import 'package:mindrealm/service/goal_image_service.dart';
import 'package:mindrealm/utils/app_assets.dart';
import 'package:mindrealm/utils/collection.dart';
import '../../../utils/app_colors.dart';

class GoalDetailController extends GetxController
    with GetTickerProviderStateMixin {
  CurrentUserController currentUserController =
      Get.find<CurrentUserController>();
  late TabController tabController;
  RxList<bool> isEditing = List.generate(4, (_) => false).obs;
  List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  Rx<UserProfileModel?> get userProfile => currentUserController.userProfile;

  RxList<String> selectedTabImages = <String>[].obs;
  RxBool isLoading = false.obs;

  var profileImage = Rx<File?>(null);
  var profileNetworkImage = Rx<String?>(null);
  final ImagePicker _picker = ImagePicker();

  final List<String> icons = [
    AppImages.yourself,
    AppImages.health,
    AppImages.love,
    AppImages.career,
    AppImages.family,
    AppImages.friend,
  ];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<String> fieldKeys = [
    'goal',
    'affirmation',
    'continue_doing',
    'improve_on',
  ];

  Rx<GoalsModel?> goalsData = Rx<GoalsModel?>(null); // Store full model

  @override
  Future<void> onInit() async {
    super.onInit();
    tabController = TabController(length: 6, vsync: this);
    tabController.addListener(() async {
      await onTabChanged();
    });
    await currentUserController.getUserProfile();

    await loadGoalData();
  }

  Future<void> onTabChanged() async {
    if (tabController.indexIsChanging) {
      for (int i = 0; i < isEditing.length; i++) {
        isEditing[i] = false;
      }
      await loadGoalData();
    }
  }

  Future<void> loadGoalData() async {
    if (userProfile.value == null) return;
    isLoading.value = true;

    try {
      final doc = await goalsCollection.doc(userProfile.value!.uid).get();

      if (doc.exists) {
        goalsData.value = GoalsModel.fromFirestore(doc);
        fillControllersForCurrentTab();
      } else {
        controllers.forEach((c) => c.clear());
      }
    } catch (e) {
      log("Error loading goal data: $e");
      Get.snackbar(
        'Error',
        'Failed to load goal data',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void fillControllersForCurrentTab() {
    GoalCategory category = getCategoryForTab();
    controllers[0].text = category.goal;
    controllers[1].text = category.affirmation;
    controllers[2].text = category.continueDoing;
    controllers[3].text = category.improveOn;
    selectedTabImages.value = category.images ?? [];
  }

  GoalCategory getCategoryForTab() {
    switch (tabController.index) {
      case 0:
        return goalsData.value?.yourself ?? GoalCategory();
      case 1:
        return goalsData.value?.health ?? GoalCategory();
      case 2:
        return goalsData.value?.love ?? GoalCategory();
      case 3:
        return goalsData.value?.career ?? GoalCategory();
      case 4:
        return goalsData.value?.family ?? GoalCategory();
      case 5:
        return goalsData.value?.friendships ?? GoalCategory();
      default:
        return GoalCategory();
    }
  }

  String getCategoryName() {
    switch (tabController.index) {
      case 0:
        return 'yourself';
      case 1:
        return 'health';
      case 2:
        return 'love';
      case 3:
        return 'career';
      case 4:
        return 'family';
      case 5:
        return 'friendships';
      default:
        return 'yourself';
    }
  }

  Future<void> saveIndividualField(int fieldIndex) async {
    if (userProfile.value == null) return;

    try {
      final categoryName = getCategoryName();
      final fieldKey = fieldKeys[fieldIndex];
      final fieldValue = controllers[fieldIndex].text.trim();

      await goalsCollection.doc(userProfile.value!.uid).set({
        categoryName: {
          fieldKey: fieldValue,
        },
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update in local model
      final category = getCategoryForTab();
      switch (fieldKey) {
        case 'goal':
          category.goal = fieldValue;
          break;
        case 'affirmation':
          category.affirmation = fieldValue;
          break;
        case 'continue_doing':
          category.continueDoing = fieldValue;
          break;
        case 'improve_on':
          category.improveOn = fieldValue;
          break;
      }

      Get.snackbar(
        'Success',
        'Field updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      log("Error saving field data: $e");
      Get.snackbar(
        'Error',
        'Failed to save field data',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  // Pick profile image
  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Reduce image quality to save storage space
      );

      if (image != null) {
        // Store the File
        profileImage.value = File(image.path);

        // Convert to Uint8List for easier handling
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }
}
