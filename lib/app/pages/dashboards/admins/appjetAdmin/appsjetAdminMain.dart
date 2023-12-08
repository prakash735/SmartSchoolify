import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/app/pages/userAccounts/subPages/addNewUser.dart';
import 'package:smartschoolify_web/app/pages/userAccounts/subPages/viewUsers.dart';
import '../../../../../components/brandAssets/brandColors.dart';
import '../../../../../global Widgets/splashScreen.dart';
import '../../../../widgets/hoveButtonTextOnly.dart';
import '../../teacher/teacherMain.dart';
import '../superAdmin/subPages/students.dart';

class AppsjetAdminMain extends StatefulWidget {
  const AppsjetAdminMain({super.key});

  @override
  State<AppsjetAdminMain> createState() => _AppsjetAdminMainState();
}

class _AppsjetAdminMainState extends State<AppsjetAdminMain> {


  List<Widget> _appsJetAdminScreen=[
    ViewUsers(),
    AddNewUser(),

  ];

  int _selectedTabIndex = 0;

  current_sideMenu() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('selectedTabIndex', _selectedTabIndex);
    var oldSideMenu = box.get('selectedTabIndex');
  }

  read_current_sideMenu()async{
    await Hive.openBox('session');
    var box = Hive.box('session');
    var oldTabMenu = box.get('selectedTabIndex');
    setState(() {
      _selectedTabIndex = oldTabMenu;
    });
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
            HoverButtonTextOnly(label: 'View Users', onPressed: () async {
              setState(() {
                _selectedTabIndex = 0;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedTabIndex==0 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),
            HoverButtonTextOnly(label: 'Add Users', onPressed: () async {
              setState(() {
                _selectedTabIndex = 1;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedTabIndex==1 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),
            // HoverButtonTextOnly(label: 'Students', onPressed: () async {
            //   setState(() {
            //     _selectedTabIndex = 3;
            //   });
            //   await current_sideMenu();
            // }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedTabIndex==3 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),



          ],
        ),
        actions: [
          Center(child: HoverButtonTextOnly(label: '${SplashScreen.userFirstName} ${SplashScreen.userLastName}', onPressed: (){}, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: ssDeepPurpleDark, textColor: ssDeepPurpleLight)),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _appsJetAdminScreen[_selectedTabIndex],
          ),
        ],
      ),
    );
  }
}
