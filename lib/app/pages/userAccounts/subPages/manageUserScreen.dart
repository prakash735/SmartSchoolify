import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartschoolify_web/app/pages/userAccounts/subPages/viewUsers.dart';
import '../../../../components/brandAssets/brandColors.dart';


class _ManageUserScreenState extends State<ManageUserScreen> {
  Map<String, bool> editModes = {
    'First Name': false,
    'Last Name': false,
    'Gender': false,
    'Email': false,
    'Phone Number': false,
  };
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String userName = '';
  // User's name
  bool isActive = false;

  get userID => fetchUserData();

  @override
  void initState() {
    super.initState();
    // Fetch the user data from Firestore and populate the controllers
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Fetch user data from Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(ViewUsers.selectedUserDocID.toString())
          .get();

      if (userData.exists) {
        setState(() {
          // Populate user data to respective controllers
          firstNameController.text = userData['firstName'] ?? '';
          lastNameController.text = userData['lastName'] ?? '';
          genderController.text = userData['gender'] ?? '';
          emailController.text = userData['emailId'] ?? '';
          phoneNumberController.text = userData['phoneNo'] ?? '';
          // Get the user's name and isActive status
          String firstName = userData['firstName'] ?? '';
          String lastName = userData['lastName'] ?? '';
          //String userID=userData['userID']??'';
          userName = '$firstName $lastName';
          isActive = userData['isActive'] ?? false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
// Inside _ManageUserScreenState class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            buildAvatarIcon(firstNameController.text),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: TextStyle(fontSize: 20)),
                SizedBox(height: 8), // Add some space between name and ID

              ],
            ),
            Spacer(),
            Switch(
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = value;
                  updateIsActive(value);
                });
              },
              activeTrackColor: ssDeepPurpleLight,
              activeColor: ssDeepPurpleDark,
              inactiveThumbColor: Colors.grey,
              splashRadius: 16,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildField('First Name','firstName', firstNameController),
            buildField('Last Name','lastName', lastNameController),
            buildField('Gender','gender', genderController),
            buildField('Email','emailId', emailController),
            buildField('Phone Number','phoneNo', phoneNumberController),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
  Widget buildField(String field, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              field,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: controller,
              enabled: isActive && (editModes[label] ?? false),
              decoration: InputDecoration(
                hintText: 'Enter $label',
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              editModes[label] ?? false ? Icons.save : Icons.edit,
            ),
            onPressed: isActive
                ? () async {
              await saveChangesToFirestore();
              setState(() {
                if (editModes[label] ?? false) {
                  saveFieldToFirestore(label, controller.text);
                }
                editModes[label] = !(editModes[label] ?? false);
              });
            }
                : null,  // Set onPressed to null if isActive is false
          ),
        ],
      ),
    );
  }
  Widget buildAvatarIcon(String firstName) {
    String firstLetter = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';

    return CircleAvatar(
      radius: 20,
      backgroundColor: ssDeepPurpleDark, // Choose your desired background color
      child: Text(
        firstLetter,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
  Future<void> saveFieldToFirestore(String fieldLabel, String fieldValue) async {
    try {
      Map<String, dynamic> updatedField = {
        fieldLabel: fieldValue,  // Use the correct field label directly
      };

      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(ViewUsers.selectedUserDocID.toString())
          .set(updatedField, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes to $fieldLabel saved')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving $fieldLabel: $error')),
      );
    }
  }
  Future<void> saveChangesToFirestore() async {
    try {
      Map<String, dynamic> updatedFields = {};

      // Check if the field is edited and add it to the updated fields
      if (editModes['First Name'] ?? false) {
        updatedFields['firstName'] = firstNameController.text;
      }

      if (editModes['Last Name'] ?? false) {
        updatedFields['lastName'] = lastNameController.text;
      }

      if (editModes['Gender'] ?? false) {
        updatedFields['gender'] = genderController.text;
      }

      if (editModes['Email'] ?? false) {
        updatedFields['emailId'] = emailController.text;
      }

      if (editModes['Phone Number'] ?? false) {
        updatedFields['phoneNo'] = phoneNumberController.text;
      }
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(ViewUsers.selectedUserDocID.toString())
          .update(updatedFields);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
  Future<void> updateIsActive(bool value) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(ViewUsers.selectedUserDocID.toString())
          .update({
        'isActive': value,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('isActive updated')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating isActive: $error')),
      );
    }
  }
}

class _selectedUserTabIndex {}

class ManageUserScreen extends StatefulWidget {
  @override
  _ManageUserScreenState createState() => _ManageUserScreenState();
}

void main() {
  runApp(MaterialApp(
    home: ManageUserScreen(),
  ));
}
