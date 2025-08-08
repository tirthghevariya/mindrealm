// User Model Class
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  String? uid;
  String? email;
  String? name;
  String? userImage;
  String? loginWith;
  DateTime? createdAt;
  String? fcmToken;

  UserProfileModel({
    this.uid,
    this.email,
    this.name,
    this.userImage,
    this.loginWith,
    this.createdAt,
    this.fcmToken,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'userImage': userImage,
      'loginWith': loginWith,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'fcmToken': fcmToken,
    };
  }

  // Create from Firestore document
  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfileModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      userImage: data['userImage'],
      loginWith: data['loginWith'],
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : null,
      fcmToken: data['fcmToken'],
    );
  }
}
