import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartschoolify_web/app/widgets/hoveButtonTextOnly.dart';
import 'package:smartschoolify_web/components/brandAssets/brandColors.dart';

import 'manageUserScreen.dart';

Color cardColor = Colors.white;
Color backgroundColor = Colors.grey[300]!;

class ViewUsers extends StatefulWidget {
  static var selectedUserDocID = '';
  const ViewUsers({Key? key}) : super(key: key);

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  int _selectedUserTabIndex = 0;
  String localSelectedUserDocID = '';

  selectedUserID(String localSelectedUserDocID) {
    setState(() {
      ViewUsers.selectedUserDocID = localSelectedUserDocID;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobileScreen = screenSize.width <= 1140 ? true : false;

    List<Widget> ViewUsers = [
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userProfile')
            .where('entityID', isEqualTo: 'SS202301')
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
            return {
              'firstName': doc['firstName'],
              'lastName': doc['lastName'],
              'gender': doc['gender'],
              'emailId': doc['emailId'],
              'isActive': doc['isActive'],
              'phoneNo': int.tryParse(doc['phoneNo'].toString()) ?? null,
              'userDocID': doc['userDocUuid']
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
                          color: cardColor,
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Text(
                                '${entry.value['firstName']} ${entry.value['lastName']}',
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text('Gender: ${entry.value['gender']}'),
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
                                    localSelectedUserDocID =
                                        entry.value['userDocID'].toString();
                                  });
                                  await selectedUserID(
                                      localSelectedUserDocID);
                                },
                                buttonBgColor: ssDeepPurpleDark,
                                onHoverBorderColor: ssDeepPurpleLight,
                                onNotHoverBorderColor:
                                _selectedUserTabIndex == 0
                                    ? ssDeepPurpleDark
                                    : ssDeepPurpleDark,
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  )
                else
                  Container(
                    margin: EdgeInsets.all(20.0), // Add margin around the table
                    padding: EdgeInsets.all(10.0), // Add padding inside the table
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0), // Add border radius if needed
                      color: Colors.white, // Set a background color for the table
                    ),
                    child: DataTable(
                      dataRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                      headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                      columns: [
                        DataColumn(label: Text('Serial')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Gender')),
                        DataColumn(label: Text('Email-ID')),
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
                            DataCell(Text(entry.value['gender'])),
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
                  ),
              ],
            ),
          );
        },
      ),
      ManageUserScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: _selectedUserTabIndex == 1
          ? AppBar(
        backgroundColor: backgroundColor,
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
      body: Container(
        color: backgroundColor, // Set page background color to grey 300
        child: ViewUsers[_selectedUserTabIndex],
      ),
    );
  }
}