import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartschoolify_web/app/widgets/hoveButtonTextOnly.dart';
import 'package:smartschoolify_web/components/brandAssets/brandColors.dart';

import '../../userAccounts/subPages/manageUserScreen.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({Key? key}) : super(key: key);
  static String selectedUserDocID = '';
  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  int _selectedUserTabIndex = 0;
  String localSelectedUserDocID = '';

  selectedUserID(String localSelectedUserDocID) {
    setState(() {
      AddAdminPage.selectedUserDocID = localSelectedUserDocID;
    });
    print(AddAdminPage.selectedUserDocID);
    print(AddAdminPage.selectedUserDocID);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobileScreen = screenSize.width <= 1140 ? true : false;

    // print('screenSize');
    //print(screenSize);
    //Responsive Screen Size

    List<Widget> ViewUsers = [
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('entity')
            .where('emailId',
                isEqualTo: 'govi@gmail.com')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No data available');
          }
          final userData = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            int? phoneNo = data.containsKey('phoneNo')
                ? int.tryParse(data['phoneNo'].toString())
                : null;
            return {
              'firstName': data['firstName'],
              'lastName': data['lastName'],
              'emailId': data['emailId'],
              'phoneNo': phoneNo,
            };
          }).toList();
          return SingleChildScrollView(
            child: Column(
              children: [
                if (isMobileScreen)
                  Column(
                    children: userData
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListTile(
                                  title: Text(
                                      '${entry.value['firstName']} ${entry.value['lastName']}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Text('Gender: ${entry.value['gender']}'),
                                      Text('Email: ${entry.value['emailId']}'),
                                      Text(
                                          'Phone Number: ${entry.value['phoneNo']}'),
                                    ],
                                  ),
                                  trailing: HoverButtonTextOnly(
                                      label: 'Manage User ',
                                      onPressed: () async {
                                        setState(() {
                                          _selectedUserTabIndex = 1;
                                          localSelectedUserDocID = entry
                                              .value['userDocID']
                                              .toString();
                                        });
                                        // print(localSelectedUserDocID);
                                        await selectedUserID(
                                            localSelectedUserDocID);
                                        // await selectedUserID(localSelectedUserDocID);
                                      },
                                      buttonBgColor: ssDeepPurpleDark,
                                      onHoverBorderColor: ssDeepPurpleLight,
                                      onNotHoverBorderColor:
                                          _selectedUserTabIndex == 0
                                              ? ssDeepPurpleLight
                                              : ssDeepPurpleDark,
                                      textColor: ssDeepPurpleLight),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                else
                  DataTable(
                    columns: [
                      DataColumn(label: Text('Serial')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Gender')),
                      //DataColumn(label: Text('Email-ID')),

                      DataColumn(label: Text('Phone number')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: userData
                        .asMap()
                        .entries
                        .map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text((entry.key + 1).toString())),
                              DataCell(Text(
                                  '${entry.value['firstName']} ${entry.value['lastName']}')),
                              //DataCell(Text(entry.value['gender'])),
                              DataCell(Text(entry.value['emailId'])),
                              DataCell(Text(entry.value['phoneNo'].toString())),
                              DataCell(
                                HoverButtonTextOnly(
                                    label: 'Manage User ',
                                    onPressed: () async {
                                      setState(() {
                                        _selectedUserTabIndex = 1;
                                        localSelectedUserDocID =
                                            entry.value['userDocID'].toString();
                                      });
                                      // print(localSelectedUserDocID);
                                      await selectedUserID(
                                          localSelectedUserDocID);
                                    },
                                    buttonBgColor: ssDeepPurpleDark,
                                    onHoverBorderColor: ssDeepPurpleLight,
                                    onNotHoverBorderColor:
                                        _selectedUserTabIndex == 0
                                            ? ssDeepPurpleLight
                                            : ssDeepPurpleDark,
                                    textColor: ssDeepPurpleLight),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
      ManageUserScreen(),
    ];

    return Scaffold(
      appBar: _selectedUserTabIndex == 1
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedUserTabIndex = 0;
                  });
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            )
          : null,
      body: ViewUsers[_selectedUserTabIndex],
    );
  }
}
