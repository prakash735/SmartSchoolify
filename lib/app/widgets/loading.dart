import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:smartschoolify_web/authentication/login.dart';

class AppLoading extends StatefulWidget {
  const AppLoading({super.key});

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {



  @override
  void initState() {
    checkData();
    super.initState();
  }

  void checkData()async{
    await Future.delayed(const Duration(seconds: 5));
    Get.offAll(()=> const Login());
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
