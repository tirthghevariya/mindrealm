import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mindrealm/routers/app_pages.dart';
import 'package:mindrealm/routers/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Enable offline persistence (new syntax)
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mind Realm',
      getPages: AppPages.listRoutes,
      initialRoute: Routes.SPLASH,
      unknownRoute: GetPage(
        name: '/notFound',
        page: () => const Scaffold(
          body: Center(
            child: Text(
              'Not Found',
            ),
          ),
        ),
      ),
    );
  }
}
