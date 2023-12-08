import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/app/widgets/hoveButtonTextOnly.dart';
import 'package:uuid/uuid.dart';
import '../../../../components/brandAssets/brandColors.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUsersState();
}

class _AddNewUsersState extends State<AddNewUser> {

  @override
  void initState() {
    read_current_sideMenu();
    super.initState();
    fetchFirestoreData();
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
  final TextEditingController firstNameTextController = TextEditingController();
  final TextEditingController lastNameTextController = TextEditingController();
  final TextEditingController dateOfBirthTextController = TextEditingController();
  final TextEditingController phoneNumberTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController Address1TextController = TextEditingController();
  final TextEditingController Address2TextController = TextEditingController();
  final TextEditingController cityTextController = TextEditingController();
  final TextEditingController pincodeTextController = TextEditingController();
  final TextEditingController stateTextController = TextEditingController();
  final TextEditingController countryTextController = TextEditingController();
  final TextEditingController ageTextController = TextEditingController();
  final TextEditingController entityIdTextController = TextEditingController();
  //textformfield controllers//

  bool isLoading = false;
  Future<void> saveUserProfile() async {
    try {
      //List<String> assignedRoles = [if (selectedroles != null) selectedroles!];
      String dobText = dateOfBirthTextController.text;
      Timestamp dobTimestamp = Timestamp.fromDate(DateTime.parse(dobText));
      var uuid = Uuid();
      String userDocUUID = uuid.v1();
      String userdocumentID = userDocUUID;
      QuerySnapshot subscriptionQuerySnapshot = await FirebaseFirestore.instance
          .collection('subscription')
          .where('plan', isEqualTo: 'user')
          .get();
      String currentSubscriptionID = '';
      if (subscriptionQuerySnapshot.docs.isNotEmpty) {
        currentSubscriptionID = subscriptionQuerySnapshot.docs.first.id;
      }
      String? address2 = Address2TextController.text.isEmpty ? 'N/A' : Address2TextController.text;
      Map<String, dynamic> userProfileData = {
        'firstName': firstNameTextController.text,
        'lastName': lastNameTextController.text,
        'entityID':entityIdTextController.text,
        'assignedRoles': selectedRoles,
        'dateOfBirth': dobTimestamp,
        'age': ageTextController.text,
        'gender': selectedGender,
        'phoneNo': phoneNumberTextController.text,
        'currentSubscriptionID': currentSubscriptionID,
        'userDocUUID': userdocumentID,
        'isActive': true,
         'defaultUserRole': 'user',
        'emailId': emailTextController.text,
        'address': {
          'address1': Address1TextController.text,
          'address2': address2,
        },
      };
      userProfileData['address']['city'] = selectedCity;
      userProfileData['address']['pinCode'] = pincodeTextController.text;
      userProfileData['address']['state'] = selectedCity;
      userProfileData['address']['country'] = selectedCountry;
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(userdocumentID)
          .set(userProfileData);
      firstNameTextController.clear();
          lastNameTextController.clear();
          dateOfBirthTextController.clear();
          ageTextController.clear();
          phoneNumberTextController.clear();
          emailTextController.clear();
          Address1TextController.clear();
          Address2TextController.clear();
          cityTextController.clear();
          pincodeTextController.clear();
          stateTextController.clear();
          countryTextController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User profile saved successfully'),
        ),
      );
      print('Document ID: $userdocumentID');
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }
  late DateTime selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dateOfBirthTextController.text = "${picked.toLocal()}".split(' ')[0];
        final age = calculateAge(picked);
        ageTextController.text = age.toString();
      });
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


  String? selectedRoles;
  List<String> roles = [
    'admin',
    'appsjetAdmin',
    'student',
    'superAdmin',
    'teacher',
  ];


  void updateStateAndCountry(String? city) {
    if (city != null && cityToStateAndCountry.containsKey(city)) {
      final parts = cityToStateAndCountry[city]!.split(', ');
      setState(() {
        selectedState = parts[0];
        selectedCountry = parts[1];
      });
    }
  }

  String? selectedGender;
  List<String> gender = [
    'Male',
    'Female',
    'Other',
  ];

  List<String> planNames = [];
  String? selectedPlan;
  Future<void> fetchFirestoreData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('subscription')
          .where('plan', isEqualTo: 'user')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          planNames = querySnapshot.docs.map((doc) => doc['type'] as String).toList();
        });
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }
// String? selectedroles;
//   List<String> roleNames = [];
//   Future<void> fetchRolesData() async {
//     try {
//       DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//           .collection('manageAccessRoles')
//           .doc('cPKl7Fq178h4XdLugFRg')
//           .get();
//
//       if (documentSnapshot.exists) {
//         final data = documentSnapshot.data() as Map<String, dynamic>?;
//
//         if (data != null && data.containsKey('roles')) {
//           final rolesMap = data['roles'] as Map<String, dynamic>;
//           setState(() {
//             roleNames = rolesMap.values.cast<String>().toList();
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching data from Firestore: $e');
//     }
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create User Profile',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color:Colors.black,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            child: TextFormField(
                              controller: firstNameTextController,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: ssBlack,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'First Name',
                                labelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: ssBlack, // Define label text color
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            child: TextFormField(
                              controller: lastNameTextController,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: ssBlack,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Last Name',
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
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Form(
                            child: TextFormField(
                              controller: entityIdTextController,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: ssBlack,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'entityID',
                                labelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: ssBlack, // Define label text color
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            child: TextFormField(
                              controller: dateOfBirthTextController,
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
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Date Of Birth',
                                suffixIcon: IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: Icon(Icons.calendar_today),
                                ),
                                labelStyle: TextStyle(
                                  color: ssBlack,
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
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

                          Form(
                            child: TextFormField(
                              controller: ageTextController,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: ssBlack,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Age',
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
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            child: DropdownButtonFormField<String>(
                              value: selectedGender,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                              items: gender.map((gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                labelText: 'Gender',
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
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            child: TextFormField(
                              controller: phoneNumberTextController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Phone number',
                                labelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: ssBlack, // Define label text color
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            child: DropdownButtonFormField<String>(
                              value: selectedRoles,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedRoles = newValue;
                                });
                              },
                              items: roles.map((city) {
                                return DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Assigned Roles',
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
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Email',
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
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
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
                            child: DropdownButtonFormField<String>(
                              value: selectedPlan,
                              onChanged: (newValue) async {
                                setState(() {
                                  selectedPlan = newValue;
                                });
                                await fetchFirestoreData();
                              },
                              items: planNames.map((plan) {
                                return DropdownMenuItem<String>(
                                  value: plan,
                                  child: Text(plan),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Subscription',
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
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Address 1',
                                labelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: ssBlack, // Define label text color
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
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
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          labelText: 'City',
                          labelStyle: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: ssBlack, // Define label text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
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
                        items: [selectedState ?? ''].map((state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'State',
                          labelStyle: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: ssBlack, // Define label text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
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
                        items: [selectedCountry ?? ''].map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Country',
                          labelStyle: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: ssBlack, // Define label text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
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
                                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                labelText: 'Pincode',
                                labelStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: ssBlack, // Define label text color
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ssBlack.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          HoverButtonTextOnly(
                            label: 'Submit',
                            onPressed: () async {

                              setState(() {

                              });
                              await saveUserProfile();
                            },
                            buttonBgColor: ssDeepPurpleDark,
                            onHoverBorderColor: ssDeepPurpleLight,
                            onNotHoverBorderColor: ssDeepPurpleDark,
                            textColor: ssDeepPurpleLight,
                          ),
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
