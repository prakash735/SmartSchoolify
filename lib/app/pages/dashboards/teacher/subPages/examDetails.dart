import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/app/pages/dashboards/teacher/subPages/ExamsResult.dart';
import 'package:smartschoolify_web/app/pages/dashboards/teacher/subPages/questionPaper.dart';

import '../../../../../components/brandAssets/brandColors.dart';
import '../../../../widgets/hoveButtonTextOnly.dart';
import '../../admins/superAdmin/superAdminMain.dart';
import 'examMarksCard.dart';
import 'examTimeTable.dart';

class ExamDetails extends StatefulWidget {
  const ExamDetails({super.key});

  @override
  State<ExamDetails> createState() => _ExamDetailsState();
}

class _ExamDetailsState extends State<ExamDetails> {

  @override
  void initState() {
    read_current_sideMenu();
    super.initState();
  }

  int _selectedExamDetailsTabIndex = 0;

  List<Widget> _ExamDetails=[
    QuestionPaper(),
    ExamTimeTable(),
    ExamMarksCard(),
    ExamsResult(),


  ];

  current_sideMenu() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('superAdminTabIndex', _selectedExamDetailsTabIndex);
    var oldSideMenu = box.get('superAdminTabIndex');
  }

  read_current_sideMenu()async{
    await Hive.openBox('session');
    var box = Hive.box('session');
    var oldSideMenu = box.get('superAdminTabIndex');
    // setState(() {
    //   _selectedSuperAdminTabIndex = oldSideMenu;
    // });
  }

  storeUserData(String userID)async{
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('userID', userID);
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
            SizedBox(width: 20,),
            HoverButtonTextOnly(label: 'Question Papers', onPressed: () async {
              setState(() {
                _selectedExamDetailsTabIndex = 0;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedExamDetailsTabIndex==0 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),
            HoverButtonTextOnly(label: 'Exam TimeTable', onPressed: () async {
              setState(() {
                _selectedExamDetailsTabIndex = 1;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedExamDetailsTabIndex==1 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),

            HoverButtonTextOnly(label: 'Marks Card', onPressed: () async {
              setState(() {
                _selectedExamDetailsTabIndex = 2;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedExamDetailsTabIndex==2 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),

            HoverButtonTextOnly(label: 'Exam Results', onPressed: () async {
              setState(() {
                _selectedExamDetailsTabIndex = 3;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedExamDetailsTabIndex==3 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),


          ],
        ),
        actions: [
          Center(child: HoverButtonTextOnly(label: '${SuperAdminMain.userFirstName} ${SuperAdminMain.userLastName}', onPressed: (){}, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: ssDeepPurpleDark, textColor: ssDeepPurpleLight)),
          SizedBox(width: 20,),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: _ExamDetails[_selectedExamDetailsTabIndex])
        ],
      ),

    );
  }
}
