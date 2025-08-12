import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindrealm/controllers/current_user_controller.dart';

class UserGoalService extends GetxController {
  final currentUserController = Get.find<CurrentUserController>();

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Observable list to track user's post images
  final userPostImages = <String>[].obs;

  // Observable list to track post data objects
  final userPosts = <String>[].obs;

  // Track if images are being loaded
  final isLoading = false.obs;

  // Maximum number of posts allowed
  final int maxPostImages = 3;

  // Collection reference for posts from collections.dart
  // final postCollection = userPostsCollection;

  @override
  void onInit() {
    super.onInit();
    loadUserPosts();
  }

  // Load user's existing posts
  Future<void> loadUserPosts() async {
    isLoading.value = true;
    try {
      userPostImages.clear();
      userPosts.clear();

      if (currentUserController.userProfile.value!.userPost?.isNotEmpty ??
          false) {
        userPosts.value =
            currentUserController.userProfile.value!.userPost ?? [];

        for (var post in userPosts) {
          userPostImages.add(post);
        }
        return;
      }
    } catch (e) {
      log("Error loading user posts: $e");
      showToast('Failed to load posts', err: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Sync posts to Firestore
  Future<void> _syncPostsToFirestore() async {
    try {
      final userId = currentUserController.userProfile.value!.uid;
      await usersCollection
          .doc(userId)
          .update({"userPost": userPosts.toList()});
      // final postModel = UserPostModel(
      //   userId: userId,
      //   posts: userPosts.toList(),
      //   updatedAt: DateTime.now(),
      // );

      // await postCollection.doc(userId).set(postModel.toMap());
    } catch (e) {
      log("Error syncing posts to Firestore: $e");
    }
  }

  // Pick image from gallery or camera
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Reduce image quality to save storage space
      );

      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      log("Error picking image: $e");
      showToast('Failed to pick image', err: true);
    }
    return null;
  }

  // Upload image to Firebase Storage with optional caption
  Future<bool> uploadPostImage(
    File imageFile,
  ) async {
    if (userPosts.length >= maxPostImages) {
      showToast(
          'Maximum $maxPostImages posts allowed. Delete an existing post first.',
          err: true);
      return false;
    }

    CommonLoader.showLoader();
    try {
      final userId = currentUserController.userProfile.value!.uid;

      // Generate a unique filename using timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = imageFile.path.split('.').last.toLowerCase();
      final fileName = '$timestamp.$fileExtension';
      // final postId = timestamp.toString(); // Use timestamp as unique ID

      // Create reference to the file path
      final filePath = 'user_goal_images/$userId/$fileName';
      final storageRef = _storage.ref().child(filePath);

      // Upload file
      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      // Get download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Create a new post data object
      final postData = downloadUrl;

      // Add to local lists
      userPostImages.add(downloadUrl);
      userPosts.add(postData);

      // Sync to Firestore
      await _syncPostsToFirestore();

      showToast('Post uploaded successfully');
      return true;
    } catch (e) {
      log("Error uploading post image: $e");
      showToast('Failed to upload image', err: true);
      return false;
    } finally {
      CommonLoader.hideLoader();
    }
  }

  // Delete a post image
  Future<bool> deletePostImage(String imageUrl) async {
    CommonLoader.showLoader();
    try {
      // Extract the path from the URL
      final userId = currentUserController.userProfile.value!.uid;

      // The URL contains a token, so we need to extract just the file name
      final urlParts = imageUrl.split('%2F');
      final fileName = urlParts.last.split('?').first;

      // Create reference to the file
      final filePath = 'user_goal_images/$userId/$fileName';
      final storageRef = _storage.ref().child(filePath);

      // Delete the file
      await storageRef.delete();

      // Remove from local lists
      userPostImages.remove(imageUrl);

      // Also remove from posts list
      userPosts.removeWhere((post) => post == imageUrl);

      // Sync to Firestore
      await _syncPostsToFirestore();

      showToast('Post deleted successfully');
      return true;
    } catch (e) {
      log("Error deleting post image: $e");
      showToast('Failed to delete image', err: true);
      return false;
    } finally {
      CommonLoader.hideLoader();
    }
  }
}
