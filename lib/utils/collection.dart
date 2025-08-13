import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String firebaseUserId() => FirebaseAuth.instance.currentUser?.uid ?? '';
User currentUser() => FirebaseAuth.instance.currentUser!;

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection("users");

CollectionReference goalsCollection =
    FirebaseFirestore.instance.collection("goals");

CollectionReference communityCollection =
    FirebaseFirestore.instance.collection("community");
