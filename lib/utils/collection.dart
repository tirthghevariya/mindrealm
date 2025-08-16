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

CollectionReference journalsCollection =
    FirebaseFirestore.instance.collection("journals");

CollectionReference dailyQuotesCollection =
    FirebaseFirestore.instance.collection("dailyQuotes");

CollectionReference dailyReflectionCollection =
    FirebaseFirestore.instance.collection("dailyReflection");

CollectionReference weeklyReflectionsCollection =
    FirebaseFirestore.instance.collection("weekly_reflections");
