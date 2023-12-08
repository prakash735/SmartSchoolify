import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smartschoolify_web/authentication/login.dart';

class WebsiteHomePage extends StatefulWidget {
  const WebsiteHomePage({super.key});

  @override
  State<WebsiteHomePage> createState() => _WebsiteHomePageState();
}

class _WebsiteHomePageState extends State<WebsiteHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Welcome To Home'),
          ElevatedButton(onPressed: (){
            Get.to(Login());
          }, child: Text('Go to Login Page')),
        ],
      ),
    );
  }
}
