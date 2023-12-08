import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:smartschoolify_web/app/widgets/hoveButtonTextOnly.dart';
import 'package:uuid/uuid.dart';
import '../../../../components/brandAssets/brandColors.dart';
import '../../userAccounts/subPages/addNewUser.dart';

class AddEntity extends StatefulWidget {
  const AddEntity({super.key});

  @override
  State<AddEntity> createState() => _AddNewUsersState();
}

class _AddNewUsersState extends State<AddEntity> {
  @override
  void initState() {
    read_current_sideMenu();
    super.initState();
    fetchFirestoreData();
    fetchRolesData();
  }

  int _selectedTabIndex = 0;

  current_sideMenu() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
    box.put('selectedTabIndex', _selectedTabIndex);
    var oldSideMenu = box.get('selectedTabIndex');
  }

  read_current_sideMenu() async {
    await Hive.openBox('session');
    var box = Hive.box('session');
    var oldTabMenu = box.get('selectedTabIndex');
    setState(() {
      _selectedTabIndex = oldTabMenu;
    });
  }

  //textformfield controllers//
  final TextEditingController entityIdTextController = TextEditingController();
  final TextEditingController entityNameTextController =
      TextEditingController();
  final TextEditingController entityNickNameTextController =
      TextEditingController();
  final TextEditingController phoneNumberTextController =
      TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController taxcodeController = TextEditingController();
  final TextEditingController Address1TextController = TextEditingController();
  final TextEditingController Address2TextController = TextEditingController();
  final TextEditingController cityTextController = TextEditingController();
  final TextEditingController pincodeTextController = TextEditingController();
  final TextEditingController stateTextController = TextEditingController();
  final TextEditingController countryTextController = TextEditingController();
  final TextEditingController ageTextController = TextEditingController();
  final TextEditingController plansTextController = TextEditingController();

  //textformfield controllers//

  bool isLoading = false;

  Future<void> saveUserProfile() async {
    int pincode = int.tryParse(pincodeTextController.text) ?? 0;
    try {
      var uuid = Uuid();
      String entityuserDocUUID = uuid.v1();
      String documentID = entityuserDocUUID;
      QuerySnapshot subscriptionQuerySnapshot = await FirebaseFirestore.instance
          .collection('subscription')
          .where('plan', isEqualTo: 'user')
          .get();
      String currentSubscriptionID = '';
      if (subscriptionQuerySnapshot.docs.isNotEmpty) {
        currentSubscriptionID = subscriptionQuerySnapshot.docs.first.id;
      }
      // DocumentSnapshot assignedIdRoles = await FirebaseFirestore.instance
      //     .collection('manageAccessRoles')
      //     .doc('cPKl7Fq178h4XdLugFRg')
      //     .get();
      // String assignedId = assignedIdRoles.id;
      Map<String, dynamic> userProfileData = {
        'entityName': entityNameTextController.text,
        'nickName': entityNickNameTextController.text,
        'phoneNo': phoneNumberTextController.text,
        'mainBranch': entityuserDocUUID,
        'taxCode': taxcodeController.text,
        'currentSubscriptionID': currentSubscriptionID,
        'emailId': emailTextController.text,
        'isActive': true,
        'address': {
          'address1': Address1TextController.text,
          'pincode': pincode,
        },
      };
      if (Address2TextController.text.isEmpty) {
        userProfileData['address']['address1'] = Address2TextController.text;
      } else {
        userProfileData['address']['address2'] = "N/A";
      }
      userProfileData['address']['city'] = selectedCity;
      userProfileData['address']['state'] = selectedCity;
      userProfileData['address']['country'] = selectedCountry;

      // Use the stored document ID to set the document data
      await FirebaseFirestore.instance
          .collection('entity')
          .doc(documentID)
          .set(userProfileData);

      // Clear text controllers and show success message
      entityIdTextController.clear();
      entityNameTextController.clear();
      entityNickNameTextController.clear();
      ageTextController.clear();
      phoneNumberTextController.clear();
      emailTextController.clear();
      Address1TextController.clear();
      Address2TextController.clear();
      cityTextController.clear();
      pincodeTextController.clear();
      stateTextController.clear();
      countryTextController.clear();
      taxcodeController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User profile saved successfully'),
        ),
      );

      print('Document ID: $documentID');
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }

  String? selectedCity;
  List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Jaipur',
    'Ahmedabad',
    'Lucknow',
    'Kochi',
    'Chandigarh',
    'Bhopal',
    'Indore',
    'Patna',
    'Nagpur',
    'Vadodara',
    'Surat',
    'Varanasi',
    'Agra',
    'Amritsar',
    'Rajkot',
    'Thiruvananthapuram',
    'Bhubaneswar',
    'Coimbatore',
    'Visakhapatnam',
    'Mangalore',
    'Nashik',
    'Vijayawada',
    'Madurai',
    'Kanpur',
    'Guwahati',
    'Aurangabad',
    'Allahabad',
    'Dehradun',
    'Ludhiana',
    'Jamshedpur',
    'Ranchi',
    'Jodhpur',
    'Gwalior',
    'Meerut',
    'Kota',
    'Srinagar',
    'Shimla',
    'Udaipur',
    'Gurgaon',
    'Noida',
    'Faridabad',
    'Ghaziabad',
  ];

  String? selectedState;
  List<String> States = [
    'Karnataka',
    'Delhi',
    'Andhra Pradesh',
    'Tamil Nadu',
  ];

  String? selectedCountry;
  List<String> COuntry = [
    'India',
    'United States',
  ];

  Map<String, String> cityToStateAndCountry = {
    'Mumbai': 'Maharashtra, India',
    'Delhi': 'Delhi, India',
    'Bengaluru': 'Karnataka, India',
    'Hyderabad': 'Telangana, India',
  };

  void updateStateAndCountry(String? city) {
    if (city != null && cityToStateAndCountry.containsKey(city)) {
      final parts = cityToStateAndCountry[city]!.split(', ');
      setState(() {
        selectedState = parts[0];
        selectedCountry = parts[1];
      });
    }
  }

  List<String> planNames = [];
  String? selectedPlan;

  Future<void> fetchFirestoreData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('subscription')
          .where('plan', isEqualTo: 'entity')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          planNames =
              querySnapshot.docs.map((doc) => doc['type'] as String).toList();
        });
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  String? selectedroles;
  List<String> roleNames = [];
  Future<void> fetchRolesData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('manageAccessRoles')
          .doc('cPKl7Fq178h4XdLugFRg')
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('roles')) {
          final rolesMap = data['roles'] as Map<String, dynamic>;
          setState(() {
            roleNames = rolesMap.values.cast<String>().toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  bool isEntityAdded = false;

  @override
  Widget build(BuildContext context) {
    return isEntityAdded
        ? AddNewUser()
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: 700,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Entity',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: TextFormField(
                                    controller: entityNameTextController,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: ssBlack,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      labelText: 'Entity Name',
                                      labelStyle: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color:
                                              ssBlack, // Define label text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: TextFormField(
                                    controller: entityNickNameTextController,
                                    style: TextStyle(
                                      color: ssBlack,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600,
                                    ).merge(GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      labelText: 'Nick Name',
                                      // suffixIcon: IconButton(
                                      //   onPressed: () => _selectDate(context),
                                      //   // icon: Icon(Icons.calendar_today),
                                      // ),
                                      labelStyle: TextStyle(
                                        color:
                                            ssBlack, // Define your label text color
                                        fontWeight: FontWeight.bold,
                                      ).merge(GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: ssBlack,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: TextFormField(
                                    controller: phoneNumberTextController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: ssBlack,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      labelText: 'Phone number',
                                      labelStyle: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color:
                                              ssBlack, // Define label text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: TextFormField(
                                    controller: emailTextController,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: ssBlack,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                      labelText: 'Email',
                                      labelStyle: GoogleFonts.lato(
                                        // Add GoogleFonts.lato to labelStyle
                                        textStyle: TextStyle(
                                          color:
                                              ssBlack, // Define label text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      }
                                      // Regular expression for basic email validation
                                      final emailRegex = RegExp(
                                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Invalid email format';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: TextFormField(
                                    controller: taxcodeController,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: ssBlack,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                      labelText: 'Tax Code',
                                      labelStyle: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: ssBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedPlan,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedPlan = newValue;
                                      });
                                    },
                                    items: planNames.map((plan) {
                                      return DropdownMenuItem<String>(
                                        value: plan,
                                        child: Text(plan),
                                      );
                                    }).toList(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      labelText: 'Select Type',
                                      labelStyle: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: ssBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: TextFormField(
                                    controller: Address1TextController,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: ssBlack,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      labelText: 'Address 1',
                                      labelStyle: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color:
                                              ssBlack, // Define label text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: TextFormField(
                                    controller: Address2TextController,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: ssBlack,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      labelText: 'Address 2',
                                      labelStyle: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: ssBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: Column(
                                    children: [
                                      DropdownButtonFormField<String>(
                                        value: selectedCity,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCity = newValue;
                                            updateStateAndCountry(selectedCity);
                                          });
                                        },
                                        items: cities.map((city) {
                                          return DropdownMenuItem<String>(
                                            value: city,
                                            child: Text(city),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          labelText: 'City',
                                          labelStyle: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color:
                                                  ssBlack, // Define label text color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black
                                                    .withOpacity(0.5)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      // Add DropdownButtonFormField for State and Country here
                                      DropdownButtonFormField<String>(
                                        value: selectedState,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedState = value;
                                          });
                                        },
                                        items:
                                            [selectedState ?? ''].map((state) {
                                          return DropdownMenuItem<String>(
                                            value: state,
                                            child: Text(state),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: 'State',
                                          labelStyle: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color:
                                                  ssBlack, // Define label text color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black
                                                    .withOpacity(0.5)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      DropdownButtonFormField<String>(
                                        value: selectedCountry,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCountry = value;
                                          });
                                        },
                                        items: [selectedCountry ?? '']
                                            .map((country) {
                                          return DropdownMenuItem<String>(
                                            value: country,
                                            child: Text(country),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: 'Country',
                                          labelStyle: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color:
                                                  ssBlack, // Define label text color
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black
                                                    .withOpacity(0.5)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  child: TextFormField(
                                    controller: pincodeTextController,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: ssBlack,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      labelText: 'Pincode',
                                      labelStyle: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color:
                                              ssBlack, // Define label text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: ssBlack),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ssBlack.withOpacity(0.5)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                HoverButtonTextOnly(
                                    label: 'Submit',
                                    onPressed: () {
                                      isEntityAdded = true;
                                      setState(() {});
                                      saveUserProfile();
                                    },
                                    buttonBgColor: ssDeepPurpleDark,
                                    onHoverBorderColor: ssDeepPurpleLight,
                                    onNotHoverBorderColor: ssDeepPurpleDark,
                                    textColor: ssDeepPurpleLight)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
