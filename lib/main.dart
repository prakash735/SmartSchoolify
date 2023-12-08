import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:smartschoolify_web/app/components/sideBar.dart';
import 'package:smartschoolify_web/authentication/login.dart';
import 'package:smartschoolify_web/global%20Widgets/splashScreen.dart';
import 'package:smartschoolify_web/website/pages/homePage.dart';

import 'app/pages/userAccounts/subPages/addNewUser.dart';
import 'app/pages/userAccounts/subPages/viewUsers.dart';
import 'app/pages/userAccounts/userAccountsMain.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyClzn9D_QYYwUBkgNGGKmnyc1QisK8TG8s",
        authDomain: "smartschoolify.firebaseapp.com",
        projectId: "smartschoolify",
        storageBucket: "smartschoolify.appspot.com",
        messagingSenderId: "1290273658",
        appId: "1:1290273658:web:4ed0b84f130bd84fb84cc3",
        measurementId: "G-VCXGNKYR3E"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static String entityTest = '';
  static String entityCounterTest = '';
  static String manageAccessRolesTest = '';
  static String subscriptionTest = '';
  static String userProfileTest = '';
  static String userProfileCounterTest = '';

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Schoolify',
      // home: WebsiteHomePage();
     // home: SplashScreen()
      // home: AddNewUser()
      home: Login()
      //home:UserAccountsMain()
      //home: ViewUsers(),
      // home: SideBar(),
    );
  }
}
