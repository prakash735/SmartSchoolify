import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/website/pages/homePage.dart';
import 'package:lottie/lottie.dart';

import '../app/components/sideBar.dart';
import '../authentication/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String userFirstName = '';
  static String userLastName = '';
  static String userID = '';
  static String userDocUUID = '';
  static String entityID = '';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    isLogined();
    super.initState();
  }

  isLogined() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
     // box.put('userID', 'SSU202301');
    var hiveUserID = box.get('userID');
    if(hiveUserID.toString().isEmpty){
      print('Login Screen');
    }else{
      setState(() {
        SplashScreen.userID = hiveUserID;
      });
      checkData();
    }
  }

  storeUserData(String userID)async{
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('userID', userID);
  }

  void checkData()async{
     await Future.delayed(const Duration(seconds: 5));
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .where('userID', isEqualTo: SplashScreen.userID)
          .get();
      if (snapshot.docs.isNotEmpty) {
        print('body of doc is ${snapshot.docs.toString()}');
        DocumentSnapshot doc = snapshot.docs.single;
        // Explicitly cast the data map to Map<String, dynamic>
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('show dataImages $data');
        SplashScreen.userDocUUID = data['userDocUUID'];
        SplashScreen.userFirstName = data['firstName'];
        SplashScreen.userLastName = data['lastName'];
        SplashScreen.userID = data['userID'];
        SplashScreen.entityID = data['entityID'];
        setState(() {});
        await storeUserData( SplashScreen.userID );
        Get.offAll(()=> const SideBar());
      } else {
        print('snapshot.docs.isEmpty');
      }
    } catch (e) {
      throw Exception('snapshot.docs.error $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/SmartSchoolifyBlueTP.png',width: 300,scale: 1,),
            Lottie.asset('assets/lottie/loading_dots.json',width: 100)
          ],
        )),
      ),
    );
  }
}
