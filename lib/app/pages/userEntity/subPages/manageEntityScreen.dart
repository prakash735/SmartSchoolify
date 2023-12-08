import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartschoolify_web/app/pages/userAccounts/subPages/viewUsers.dart';
import 'package:smartschoolify_web/app/pages/userEntity/subPages/viewEntity.dart';

import '../../../../components/brandAssets/brandColors.dart';


class _ManageEntityScreenState extends State<ManageEntityScreen> {
  Map<String, bool> editModes = {
    'School Name': false,
    'Nick Name': false,
    'Phone Number': false,
    'Email': false,
  };

  var selectedEntityDocID = '';


  TextEditingController entityNameController = TextEditingController();
  TextEditingController entitynameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();


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
      DocumentSnapshot entityData = await FirebaseFirestore.instance
          .collection('entity')
          .doc(ViewEntity.selectedEntityDocID)
          .get();

      print('Fetched user data: ${entityData.data()}');
      if (entityData.exists) {
        setState(() {
          // Populate user data to respective controllers
          entityNameController.text = entityData['entityName'] ?? '';
          entitynameController.text = entityData['nickName'] ?? '';
          phoneNumberController.text = entityData['phoneNo'] ?? '';
          emailController.text = entityData['emailId'] ?? '';

          // Get the user's name and isActive status
          userName = entityData['entityName'] ?? '';
          isActive = entityData['isActive'] ?? false;
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
            buildAvatarIcon(entityNameController.text),
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
            buildField('School Name','entityName', entityNameController),
            buildField('Nick Name','nickName', entitynameController),
            buildField('Phone Number','phoneNo', phoneNumberController),
            buildField('Email','emailId', emailController),
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
              controller: controller,  // Use the correct controller here
              enabled: isActive && (editModes[label] ?? false),
              decoration: InputDecoration(
                hintText: 'Enter $label',
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              editModes[label] ?? false ? Icons.save: Icons.edit,
            ),
            onPressed: isActive
                ? () async {
              // Save changes to Firestore
              await saveChangesToFirestore();
              setState(() {
                if (editModes[label] ?? false) {
                  saveFieldToFirestore(label, controller.text);
                }
                editModes[label] = !(editModes[label] ?? false);
              });
            }
                : null, // Set onPressed to null if isActive is false
          ),
        ],
      ),
    );
  }




  Widget buildAvatarIcon(String schoolname) {
    String firstLetter = schoolname.isNotEmpty ? schoolname[0].toUpperCase() : '';

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
          .collection('entity')
          .doc(ViewEntity.selectedEntityDocID="".toString())
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
      if (editModes['School Name'] ?? false) {
        updatedFields['etityName'] = entityNameController.text;
      }

      if (editModes['Nick Name'] ?? false) {
        updatedFields['entityNickName'] = entitynameController.text;
      }

      if (editModes['Phone Number'] ?? false) {
        updatedFields['phoneNo'] = phoneNumberController.text;
      }

      if (editModes['Email'] ?? false) {
        updatedFields['emailId'] = emailController.text;
      }



      // Update the fields in Firestore
      await FirebaseFirestore.instance
          .collection('entity')
          .doc(ViewEntity.selectedEntityDocID.toString())
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
          .collection('entity')
          .doc(ViewEntity.selectedEntityDocID.toString())
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

class ManageEntityScreen extends StatefulWidget {
  @override
  _ManageEntityScreenState createState() => _ManageEntityScreenState();
}

void main() {
  runApp(MaterialApp(
    home: ManageEntityScreen(),
  ));
}
