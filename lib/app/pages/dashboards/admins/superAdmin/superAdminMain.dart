import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/app/pages/dashboards/admins/superAdmin/subPages/accounts.dart';
import 'package:smartschoolify_web/app/pages/dashboards/admins/superAdmin/subPages/students.dart';
import 'package:smartschoolify_web/app/pages/userAccounts/subPages/viewUsers.dart';
import 'package:smartschoolify_web/app/pages/userEntity/subPages/addEntity.dart';
import 'package:smartschoolify_web/app/pages/userEntity/subPages/viewEntity.dart';
import 'package:smartschoolify_web/components/brandAssets/brandColors.dart';
import '../../../../../authentication/login.dart';
import '../../../../../global Widgets/splashScreen.dart';
import '../../../../components/sideBar.dart';
import '../../../../widgets/hoveButtonTextOnly.dart';
import '../../../userAccounts/subPages/manageUserScreen.dart';
import '../../../userAccounts/subPages/addNewUser.dart';
import '../../../userAccounts/userAccountsMain.dart';

class SuperAdminMain extends StatefulWidget {
  static String userFirstName = '';
  static String userLastName = '';
  static String userID = '';
  static String userDocUUID = '';
  static String entityID = '';
  const SuperAdminMain({super.key});

  @override
  State<SuperAdminMain> createState() => _SuperAdminMainState();
}

class _SuperAdminMainState extends State<SuperAdminMain> {

  @override
  void initState() {
    read_current_sideMenu();
    super.initState();
  }

int _selectedSuperAdminTabIndex = 0;

  List<Widget> _superAdminScreen=[
    Accounts(),
    AddEntity(),
    ViewEntity(),
    AddNewUser(),
    ViewUsers()
  ];

  current_sideMenu() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('superAdminTabIndex', _selectedSuperAdminTabIndex);
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

  void checkData()async{
    await Future.delayed(const Duration(seconds: 5));
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .where('entityID', isEqualTo: 'SS202301')
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
        await storeUserData( SuperAdminMain.userID );
        // Get.offAll(()=> const SideBar());
      } else {
        print('snapshot.docs.isEmpty');
      }
    } catch (e) {
      throw Exception('snapshot.docs.error $e');
    }

  }
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    //Responsive Screen Size
    var screenSize = MediaQuery.of(context).size;
    bool isMobileScreen = screenSize.width <= 700 ? true : false;
    isMobileScreen ? setState(() {isExpanded == false;}):null;
    //Responsive Screen Size
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
            HoverButtonTextOnly(label: 'Accounts', onPressed: () async {
              setState(() {
                _selectedSuperAdminTabIndex = 0;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedSuperAdminTabIndex==0 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),
            HoverButtonTextOnly(label: 'Add Entity', onPressed: () async {
              setState(() {
                _selectedSuperAdminTabIndex = 1;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedSuperAdminTabIndex==1 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),

            HoverButtonTextOnly(label: 'View Entity', onPressed: () async {
              setState(() {
                _selectedSuperAdminTabIndex = 2;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedSuperAdminTabIndex==2 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),


            HoverButtonTextOnly(label: 'Add Users', onPressed: () async {
              setState(() {
                _selectedSuperAdminTabIndex = 3;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedSuperAdminTabIndex==3 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),

            HoverButtonTextOnly(label: 'View Users', onPressed: () async {
              setState(() {
                _selectedSuperAdminTabIndex = 4;
              });
              await current_sideMenu();
            }, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: _selectedSuperAdminTabIndex==4 ?ssDeepPurpleLight:ssDeepPurpleDark, textColor: ssDeepPurpleLight),


          ],
        ),
        actions: [
          Center(child: HoverButtonTextOnly(label: '${SuperAdminMain.userFirstName} ${SuperAdminMain.userLastName}', onPressed: (){}, buttonBgColor: ssDeepPurpleDark, onHoverBorderColor: ssDeepPurpleLight, onNotHoverBorderColor: ssDeepPurpleDark, textColor: ssDeepPurpleLight)),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _superAdminScreen[_selectedSuperAdminTabIndex],
          ),
        ],
      ),
    );
  }
}
