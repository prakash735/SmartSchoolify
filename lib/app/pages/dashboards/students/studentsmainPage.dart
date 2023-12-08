import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/app/pages/dashboards/students/subpage/studentAttendance.dart';
import 'package:smartschoolify_web/app/pages/dashboards/students/subpage/studentCertificate.dart';
import 'package:smartschoolify_web/app/pages/dashboards/students/subpage/studentTimetable.dart';

import '../../../../components/brandAssets/brandColors.dart';
import '../../../../global Widgets/splashScreen.dart';
import '../../../widgets/hoveButtonTextOnly.dart';

class StudentsMainPage extends StatefulWidget {
  const StudentsMainPage({super.key});

  @override
  State<StudentsMainPage> createState() => _StudentsMainPageState();
}

class _StudentsMainPageState extends State<StudentsMainPage> {
  @override
  int _selectedTeacherMainTabIndex = 0;

  List<Widget> _TeacherMainPage=[
    StudentAttendence(),
    TimeTable(),
    StudentCertificate()
  ];

  current_sideMenu() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('selectedTabIndex', _selectedTeacherMainTabIndex);
    var oldSideMenu = box.get('selectedTabIndex');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ssDeepPurpleDark,
        leadingWidth: 0,
        titleSpacing: 0,
        centerTitle: false,
        title: Row(
          mainAxisSize:  MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10,),
            HoverButtonTextOnly(label: 'Attendance', onPressed: () async {
              setState(() {
                _selectedTeacherMainTabIndex = 0;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedTeacherMainTabIndex==0 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),

            SizedBox(width: 10,),

            HoverButtonTextOnly(label: 'TimeTable', onPressed: () async {
              setState(() {
                _selectedTeacherMainTabIndex = 1;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedTeacherMainTabIndex==1 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),

            SizedBox(width: 10,),

            HoverButtonTextOnly(label: 'Certificate', onPressed: () async {
              setState(() {
                _selectedTeacherMainTabIndex = 2;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedTeacherMainTabIndex==2 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),
          ],
        ),
        actions: [
          Center(child: HoverButtonTextOnly(label: '${SplashScreen.userFirstName} ${SplashScreen.userLastName}', onPressed: (){}, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: ssDeepPurpleDark, textColor: ssDeepPurpleLight)),
          SizedBox(width: 20,),
        ],
      ),
      body:  Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border.all(color: Colors.black.withOpacity(0.2)),
            //     borderRadius: BorderRadius.circular(8.0),
            //   ),
            //   //child: Text('Teacher MainPage'),
            //
            // ),
            Expanded(child: _TeacherMainPage[_selectedTeacherMainTabIndex])
          ],
        ),
      ),


    );
  }
}
