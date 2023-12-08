import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartschoolify_web/app/components/sideBar.dart';
import 'package:smartschoolify_web/app/pages/dashboards/students/subpage/studentTimetable.dart';
import 'package:smartschoolify_web/components/brandAssets/brandColors.dart';
import '../app/pages/dashboards/admins/superAdmin/superAdminMain.dart';
import '../app/pages/dashboards/teacher/teacherMain.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static String UserId = '';
  static String UserPassword = '';
  static String userId = '';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  bool isEnabled = true;
  bool isOTPSent = false;

  final TextEditingController userIDTextController = TextEditingController();
  final TextEditingController otpTextController = TextEditingController();



  // this is for fetch userid
  bool isUserIdValid = false;
  Future<void> checkUserId(String enteredUserId) async {
    setState(() {
      isLoading = false;
    });

    try {
      await Future.delayed(Duration(seconds: 2));
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .where('entityID', isEqualTo: enteredUserId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          isUserIdValid = true;
        });
      } else {
        setState(() {
          isUserIdValid = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  // end here


// otp or passcode fetch here//
  Future<bool> CheckingOtp(String enteredOtp) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .where('firstName', isEqualTo: enteredOtp)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking OTP: $e');
      return false;
    }
  }
  // end here//





  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      title: 'Log in to Smart Schoolify ',
      child: Scaffold(
        backgroundColor: ssDeepPurpleLight,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   toolbarHeight: 100,
        //   titleSpacing: 20,
        //   title: Image.asset('assets/logo/SmartSchoolifyBlueTP.png',width: 200,scale: 1,),
        //   actions: [
        //     IconButton(onPressed: (){}, icon: Icon(Icons.help,size: 24,color: ssBlack,)),
        //     SizedBox(width: 20,)
        //   ],
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            width: 700,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Elevate Your School\'s Potential',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: ssDeepPurpleDark,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 54,
                                    ),
                                  ),),
                                // SizedBox(height: 10,),
                                // DefaultTextStyle(
                                //   style: GoogleFonts.lato(
                                //     textStyle: TextStyle(
                                //       color: ssDeepPurpleDark,
                                //       letterSpacing: 0.5,
                                //       fontWeight: FontWeight.w900,
                                //       fontSize: 54,
                                //     ),
                                //   ),
                                //   child: AnimatedTextKit(
                                //     animatedTexts: [
                                //       RotateAnimatedText('Potential'),
                                //       RotateAnimatedText('Management'),
                                //       RotateAnimatedText('Academic '),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(height: 10,),
                                Text('Join us in revolutionizing education through innovation and witness the future of school management.',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: ssDeepPurpleDark,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),),
                                SizedBox(height: 10,),
                                Form(
                                  child: TextFormField(
                                    controller: userIDTextController,
                                    onChanged: (value) {
                                      checkUserId(value);
                                      Login.userId = value.trim();
                                    }, // enabled: isOTPSent,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: ssDeepPurpleDark,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(
                                            vertical: 5
                                        ),
                                        labelText: 'User ID',
                                        suffix: isLoading? const CupertinoActivityIndicator(
                                          color: Colors.blueAccent,
                                        ):IconButton(
                                          onPressed: () async {
                                            String userId = userIDTextController.text.trim();
                                            if (userId.isNotEmpty) {
                                              setState(() {
                                                isLoading = false;
                                                isOTPSent=!isOTPSent;
                                              });

                                              setState(() {
                                                isLoading = true;
                                              });
                                            }
                                          },
                                          icon: Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              Icon(CupertinoIcons.arrow_right_circle),
                                              if (isLoading)
                                                SizedBox(
                                                  width: 24.0,
                                                  height: 24.0,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      Colors.black,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),


                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(8),
                                    ],
                                  ),

                                ),
                                const SizedBox(height: 10,),
                                Visibility(
                                  visible: isOTPSent,
                                  child: Form(
                                    child: TextFormField(
                                      controller: otpTextController,
                                      onChanged: (value) {
                                        if (value.length == 8) {
                                          CheckingOtp(value).then((isOtpValid) {
                                            if (isOtpValid) {
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => const SideBar(),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Your OTP is Invalid. Please try again.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                      enabled: true,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: ssDeepPurpleDark,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        labelText: 'OTP',
                                        suffix: isLoading
                                            ? const CupertinoActivityIndicator(
                                          color: Colors.blueAccent,
                                        )
                                            : TextButton(
                                          onPressed: () {
                                          },
                                          child: const Text('Resend OTP'),
                                        ),
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(8),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     if (isUserIdValid && isOtpValid) {
                                //       Get.offAll(() => SuperAdminMain());
                                //     } else {
                                //       ScaffoldMessenger.of(context).showSnackBar(
                                //         SnackBar(
                                //           content: Text('Invalid User ID or OTP. Please try again.'),
                                //           backgroundColor: Colors.red,
                                //         ),
                                //       );
                                //     }
                                //   },
                                //   child: Text('Login'),
                                // ),

                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text('Contact Our Team?',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: ssDeepPurpleDark,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),),
                                    SizedBox(width: 10,),
                                    InkWell(
                                      onTap: (){},
                                      child: Text('Click here',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            color: ssBlack,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  }

