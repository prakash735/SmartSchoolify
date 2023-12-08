import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/app/pages/dashboards/teacher/subPages/studentslist.dart';
import 'package:smartschoolify_web/app/pages/dashboards/teacher/subPages/subjects.dart';
import 'package:smartschoolify_web/app/pages/dashboards/teacher/subPages/teacherAttendance.dart';

import '../../../../components/brandAssets/brandColors.dart';
import '../../../../global Widgets/splashScreen.dart';
import '../../../widgets/hoveButtonTextOnly.dart';

class Teachers extends StatefulWidget {
  const Teachers({super.key});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  int _selectedTeacherMainTabIndex = 0;

  List<Widget> _TeacherMainPage=[
    TeacherAttendance(),
    TeacherAttendance(),
    TeachersSubjects(),
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

            HoverButtonTextOnly(label: 'Subjects', onPressed: () async {
              setState(() {
                _selectedTeacherMainTabIndex = 2;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedTeacherMainTabIndex==2 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),

            SizedBox(width: 10,),

            HoverButtonTextOnly(label: 'Student Details', onPressed: () async {
              setState(() {
                _selectedTeacherMainTabIndex = 3;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedTeacherMainTabIndex==3 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),


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
