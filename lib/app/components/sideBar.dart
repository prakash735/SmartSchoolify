import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/app/pages/dashboards/admins/superAdmin/subPages/addmissionPage.dart';
import 'package:smartschoolify_web/app/pages/dashboards/admins/superAdmin/subPages/paymentDetails.dart';
import 'package:smartschoolify_web/app/pages/dashboards/admins/superAdmin/subPages/students.dart';
import 'package:smartschoolify_web/app/pages/dashboards/admins/superAdmin/superAdminMain.dart';
import 'package:smartschoolify_web/app/pages/dashboards/students/studentsmainPage.dart';
import 'package:smartschoolify_web/app/pages/userAccounts/subPages/viewUsers.dart';
import 'package:smartschoolify_web/app/pages/userAccounts/userAccountsMain.dart';
import 'package:smartschoolify_web/app/pages/userEntity/userEntityMain.dart';
import '../../authentication/login.dart';
import '../../components/brandAssets/brandColors.dart';
import '../pages/dashboards/admins/appjetAdmin/appsjetAdminMain.dart';
import '../pages/dashboards/students/subpage/studentExams.dart';
import '../pages/dashboards/students/subpage/studentTimetable.dart';
import '../pages/dashboards/teacher/subPages/examDetails.dart';
import '../pages/dashboards/teacher/subPages/teacherTimetable.dart';
import '../pages/dashboards/teacher/teacherMain.dart';
import '../pages/userAccounts/subPages/addNewUser.dart';

class SideBar extends StatefulWidget {
  //final List<Widget> pages;
  
  const SideBar({super.key});
  @override
  State<SideBar> createState() => _SideBarState();
}
class _SideBarState extends State<SideBar> {
  @override
  void initState() {
    read_current_sideMenu();
    super.initState();
    fetchDefaultUserRole();
    fetchAssignedRoles();
  }
  int _selectedIndex = 0;
  bool isExpanded = true;
  late final List<Widget> pages;






  //Login as user
  List<Widget> _screen=[
    AppsjetAdminMain(),
    UserAccountsMain(),
    UserEntityMain(),
  ];
  //Login as

  List<Widget> _teacherScreen = [
    Teachers(),
    ExamDetails(),
    // TeacherTimeTable(),
  ];

  List<Widget> _adminScreen = [
    SuperAdminMain(),
    AddmissionPage(),
    PaymentDetails()
  ];

  List<Widget> _studentScreen = [
    StudentsMainPage(),
    StudentExams()
  ];

  List<Widget> _appsJetAdminScreen = [
    AppsjetAdminMain(),
    SuperAdminMain(),
    Students(),
    Teachers()
  ];


  current_sideMenu() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('current_Menu', _selectedIndex);
    var oldSideMenu = box.get('current_Menu');
  }

  read_current_sideMenu()async{
    await Hive.openBox('session');
    var box = Hive.box('session');
    var oldSideMenu = box.get('current_Menu');
    setState(() {
      _selectedIndex = oldSideMenu;
    });
  }

  clearTabIndex() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('selectedTabIndex',0);
    var oldSideMenu = box.get('selectedTabIndex');
  }

  List<NavigationRailDestination> generateDestinationsForRole(String role) {
    List<NavigationRailDestination> destinations = [];
    if (role == 'teacher') {
      destinations = [
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Teacher Page')),
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Exams')),
        // NavigationRailDestination(icon: Icon(Icons.view_timeline), label: Text('TimeTable')),
      ];
    } else if (role == 'admin') {
      destinations = [
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Admin Page')),
        NavigationRailDestination(icon: Icon(Icons.book), label: Text('Addmission Details')),
        NavigationRailDestination(icon: Icon(Icons.currency_rupee), label: Text('payment Details')),
      ];
    } else if (role == 'student') {
      destinations = [
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Student Page')),
        NavigationRailDestination(icon: Icon(Icons.view_timeline), label: Text('Exams')),
      ];
    } else if (role == 'appsJetAdmin') {
      destinations = [
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('AppsJet Admin Page')),
        NavigationRailDestination(icon: Icon(Icons.admin_panel_settings), label: Text('SuperAdmin Page')),
        NavigationRailDestination(icon: Icon(Icons.flight_class), label: Text('Student Page')),
        NavigationRailDestination(icon: Icon(Icons.people_outline_sharp), label: Text('Teacher Page')),
      ];
    } else if ('users' == 'users'){
      destinations = [
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
        NavigationRailDestination(icon: Icon(Icons.supervised_user_circle_sharp), label: Text('User Accounts')),
        NavigationRailDestination(icon: Icon(Icons.pending_actions), label: Text('Entity Users')),
      ];
    }
    return destinations??[];
  }

  Future<void> fetchDefaultUserRole() async {
    try {
      String user=Login.userId;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc('35a4a700-3771-1d06-86d3-ab843a8e6580')
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('defaultUserRole')) {
          setState(() {
            defaultUserRole = data['defaultUserRole'];
          });
        }
      }
    } catch (e) {
      print('Error fetching default user role from Firestore: $e');
    }
  }
  Future<void> fetchAssignedRoles() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc('35a4a700-3771-1d06-86d3-ab843a8e6580')
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('assignedRoles')) {
          setState(() {
            assignedRoles = List<String>.from(data['assignedRoles']);
          });
        }
      }
    } catch (e) {
      print('Error fetching assigned roles from Firestore: $e');
    }
  }
  String defaultUserRole = '';
  List<String> assignedRoles = [];

  @override
  Widget build(BuildContext context) {
    //Responsive Screen Size
    var screenSize = MediaQuery.of(context).size;
    bool isMobileScreen = screenSize.width <= 700 ? true : false;
     isMobileScreen ? setState(() {isExpanded == false;}):null;
    //Responsive Screen Size
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 50,
        titleSpacing: 20,
        title: Image.asset('assets/logo/SmartSchoolifyBlueTP.png',width: 100,scale: 1,),
        actions: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: GetBuilder<MyController>(
              init: MyController(),
              builder: (controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<String>(
                      underline: Container(),
                      value: defaultUserRole,
                      onChanged: (String? newValue) {
                        setState(() {
                          defaultUserRole = newValue!;
                        });
                      },
                      items: assignedRoles.map(( role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(Login.userId),
          IconButton(onPressed: (){}, icon: Icon(Icons.help,size: 18,color: ssBlack,)),

          SizedBox(width: 20,)
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
              onDestinationSelected: (int index) async {
                setState(() {
                  _selectedIndex = index;
                });
                await current_sideMenu();
                await clearTabIndex();
              },
              elevation: 2,
              selectedIconTheme: IconThemeData(color: ssDeepPurpleRegular),
              selectedLabelTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: ssDeepPurpleDark,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),),
              extended: isExpanded,
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(onPressed: (){
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  }, icon: isExpanded?Icon(Icons.arrow_back_ios,size: 15,):Icon(Icons.arrow_forward_ios,size: 15,)),
                ),
              ),
              // destinations: generateDestinations(
              //     defaultUserRole == 'teacher'
              //         ? _teacherScreen
              //         : defaultUserRole == 'admin'
              //         ? _adminScreen
              //         : defaultUserRole == 'student'
              //         ? _studentScreen
              //         : defaultUserRole == 'appsJetAdmin'
              //         ? _appsJetAdminScreen
              //         : _screen),
              // destinations: const [
              //   NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard',)),
              //   NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('User Accounts',)),
              //   NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Entity Users',)),
              //   // NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Teacher',)),
              // ],
              destinations: generateDestinationsForRole(defaultUserRole),
              selectedIndex: _selectedIndex),
          //Expanded(child: _screen[_selectedIndex]),
          Expanded(
            child: defaultUserRole == 'teacher'
                ? _teacherScreen[_selectedIndex]
                : defaultUserRole == 'admin'
                ? _adminScreen[_selectedIndex]
                : defaultUserRole == 'student'
                ? _studentScreen[_selectedIndex]
                : defaultUserRole == 'appsJetAdmin'
                ? _appsJetAdminScreen[_selectedIndex]
                : defaultUserRole == 'users'
                ?_screen[_selectedIndex]
                : _screen[_selectedIndex],
          )
        ],
      ),
    );
  }
}

class MyController extends GetxController {
  void navigateToSuperAccessPage(String defaultUserRole) {
    Get.to(UserAccountsMain());
  }
}


