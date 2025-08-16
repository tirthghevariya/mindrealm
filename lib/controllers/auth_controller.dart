import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindrealm/models/user_model.dart';
import 'package:mindrealm/routers/app_routes.dart';
import 'package:mindrealm/utils/app_colors.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/common_loader.dart';
import 'package:mindrealm/widgets/common_tost.dart';

class AuthController extends GetxController {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Form keys
  final signInformKey = GlobalKey<FormState>();
  final signUpformKey = GlobalKey<FormState>();

  // Login Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // SignUp Controllers
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUPConfirmPasswordController = TextEditingController();

  // Observables
  RxBool passwordsMatch = true.obs;

  // User data
  Rx<User?> firebaseUser = Rx<User?>(null);
  Rx<UserProfileModel> userProfile = UserProfileModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Check if user is already logged in
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      firebaseUser.value = _auth.currentUser;
      if (firebaseUser.value != null) {
        await fetchUserProfile(firebaseUser.value!.uid);
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUPConfirmPasswordController.dispose();
    super.dispose();
  }

  // Fetch user profile from Firestore
  Future<void> fetchUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(uid).get();
      if (doc.exists) {
        userProfile.value = UserProfileModel.fromFirestore(doc);
      }
    } catch (e) {
      debugPrint("Error fetching user profile: $e");
    }
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value) {
    if (value != signUpPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Generate a random unique ID in the format XXX-XXX-XXX-XX
  // Get FCM Token
  Future<String?> getFCMToken() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return await _firebaseMessaging.getToken();
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
    return null;
  }

  // Email/Password login
  Future<void> loginWithEmail() async {
    if (!signInformKey.currentState!.validate()) return;

    try {
      CommonLoader.showLoader();

      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Update FCM token
        String? fcmToken = await getFCMToken();
        if (fcmToken != null) {
          await usersCollection
              .doc(userCredential.user!.uid)
              .update({'fcmToken': fcmToken});
        }

        // Fetch user profile
        await fetchUserProfile(userCredential.user!.uid);

        Get.offAllNamed(Routes.bottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-credential':
          message = 'Invalid credentials. Please check your email and password';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later';
          break;
        default:
          message = 'Login failed. Please try again';
      }
      showToast(message, err: true);
    } catch (e) {
      showToast("An unexpected error occurred", err: true);
    } finally {
      CommonLoader.hideLoader();
    }
  }

  // Email/Password signup
  Future<void> signUpWithEmail() async {
    if (!signUpformKey.currentState!.validate()) return;

    if (signUpPasswordController.text != signUPConfirmPasswordController.text) {
      passwordsMatch.value = false;
      return;
    }

    passwordsMatch.value = true;

    try {
      CommonLoader.showLoader();

      // Check if email already exists
      final methods = await _auth
          // ignore: deprecated_member_use
          .fetchSignInMethodsForEmail(signUpEmailController.text.trim());

      if (methods.isNotEmpty) {
        showToast("An account already exists with this email", err: true);

        return;
      }

      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: signUpEmailController.text.trim(),
        password: signUpPasswordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Get FCM token
        String? fcmToken = await getFCMToken();

        // Create user profile
        UserProfileModel newUser = UserProfileModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email,
          name: userCredential.user!.displayName,
          userImage: userCredential.user!.photoURL,
          loginWith: 'email',
          createdAt: DateTime.now(),
          fcmToken: fcmToken,
        );

        // Save to Firestore
        await usersCollection
            .doc(userCredential.user!.uid)
            .set(newUser.toMap());

        userProfile.value = newUser;

        // Navigate directly to home screen (no email verification required)
        Get.offAllNamed(Routes.bottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account already exists with this email';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        default:
          message = 'Registration failed. Please try again';
      }
      showToast("Registration Error", err: true);
    } catch (e) {
      showToast("An unexpected error occurred", err: true);
    } finally {
      CommonLoader.hideLoader();
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      CommonLoader.showLoader();

      await signOut();

      // Start the Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        CommonLoader.hideLoader();

        return;
      }

      // Obtain auth details from Google Sign In
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential for Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        DocumentSnapshot userDoc = await usersCollection.doc(user.uid).get();

        if (!userDoc.exists) {
          // Create new user profile
          String? fcmToken = await getFCMToken();

          UserProfileModel newUser = UserProfileModel(
            uid: user.uid,
            email: user.email,
            name: user.displayName,
            userImage: user.photoURL,
            loginWith: 'google',
            createdAt: DateTime.now(),
            fcmToken: fcmToken,
          );

          await usersCollection.doc(user.uid).set(newUser.toMap());
          userProfile.value = newUser;
        } else {
          userProfile.value = UserProfileModel.fromFirestore(userDoc);

          // Update FCM token for existing user
          String? fcmToken = await getFCMToken();
          if (fcmToken != null) {
            await usersCollection.doc(user.uid).update({'fcmToken': fcmToken});
          }
        }

        Get.offAllNamed(Routes.bottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      showToast(e.message ?? 'An error occurred', err: true);
    } on PlatformException catch (e) {
      showToast(e.message ?? 'An error occurred', err: true);
    } catch (e) {
      showToast('Failed to sign in with Google', err: true);
    } finally {
      CommonLoader.hideLoader();
    }
  }

  // Sign out
  Future<void> signOut({bool navigateToLogin = false}) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Clear user data
      userProfile.value = UserProfileModel();
      firebaseUser.value = null;

      // Clear form fields
      emailController.clear();
      passwordController.clear();
      signUpEmailController.clear();
      signUpPasswordController.clear();
      signUPConfirmPasswordController.clear();

      if (navigateToLogin) {
        Get.offAllNamed(Routes.loginScreen);
      }
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  // Password reset functionality
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      showToast('Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        default:
          message = 'Failed to send reset email';
      }
      showToast(message, err: true);
    }
  }
}
