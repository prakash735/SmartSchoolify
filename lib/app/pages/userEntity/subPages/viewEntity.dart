import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smartschoolify_web/app/widgets/hoveButtonTextOnly.dart';
import 'package:smartschoolify_web/components/brandAssets/brandColors.dart';

import 'manageEntityScreen.dart';

class ViewEntity extends StatefulWidget {
  const ViewEntity({Key? key}) : super(key: key);
  static String selectedEntityDocID = '';

  @override
  State<ViewEntity> createState() => _ViewEntityState();
}

class _ViewEntityState extends State<ViewEntity> {
  int _selectedEntityTabIndex = 0;
  String localSelectedEntityDocID = '';
  static var selectedEntityDocID = '';
  selectedEntityID(String localSelectedEntityDocID) {
    setState(() {
      ViewEntity.selectedEntityDocID = localSelectedEntityDocID;
    });
    print(ViewEntity.selectedEntityDocID);
    print(ViewEntity.selectedEntityDocID);
  }

  @override
  Widget build(BuildContext context) {
    //Responsive Screen Size
    var screenSize = MediaQuery.of(context).size;
    bool isMobileScreen = screenSize.width <= 1140 ? true : false;

    // print('screenSize');
    //print(screenSize);
    //Responsive Screen Size

    List<Widget> ViewEntity = [
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('entity').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No data available');
          }

          // Extract user data from Firebase

          final entityData = snapshot.data!.docs.map((doc) {
            return {
              'entityName': doc['entityName'],
              'nickName': doc['nickName'],
              'phoneNo': int.tryParse(doc['phoneNo'].toString()) ?? null,
              'emailId': doc['emailId'],
              'isActive': doc['isActive'],
              //'entityID':doc['entityID'],

              'mainBranch': doc['mainBranch']
            };
          }).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                if (isMobileScreen)
                  Column(
                    children: entityData
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
                                      '${entry.value['entityName']} ${entry.value['nickName']}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Phone number: ${entry.value['phoneNo']}'),
                                      Text('Email: ${entry.value['emailId']}'),
                                    ],
                                  ),
                                  trailing: HoverButtonTextOnly(
                                    label: 'Manage entity ',
                                    onPressed: () async {
                                      setState(() {
                                        _selectedEntityTabIndex = 1;
                                        localSelectedEntityDocID = entry
                                            .value['mainBranch']
                                            .toString();
                                      });
                                      await selectedEntityID(
                                          localSelectedEntityDocID);
                                    },
                                    buttonBgColor: ssDeepPurpleDark,
                                    onHoverBorderColor: ssDeepPurpleLight,
                                    onNotHoverBorderColor:
                                        _selectedEntityTabIndex == 0
                                            ? ssDeepPurpleLight
                                            : ssDeepPurpleDark,
                                    textColor: ssDeepPurpleLight,
                                  ),
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
                      DataColumn(label: Text('School Name')),
                      DataColumn(label: Text('Nick Name')),
                      DataColumn(label: Text('Phone number')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: entityData
                        .asMap()
                        .entries
                        .map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text((entry.key + 1).toString())),
                              DataCell(Text('${entry.value['entityName']}')),
                              DataCell(Text('${entry.value['nickName']}')),
                              DataCell(Text('${entry.value['phoneNo']}')),
                              DataCell(Text('${entry.value['emailId']}')),
                              DataCell(
                                HoverButtonTextOnly(
                                  label: 'Manage entity',
                                  onPressed: () async {
                                    setState(() {
                                      _selectedEntityTabIndex = 1;
                                      localSelectedEntityDocID =
                                          entry.value['mainBranch'].toString();
                                    });
                                    await selectedEntityID(
                                        localSelectedEntityDocID);
                                  },
                                  buttonBgColor: ssDeepPurpleDark,
                                  onHoverBorderColor: ssDeepPurpleLight,
                                  onNotHoverBorderColor:
                                      _selectedEntityTabIndex == 0
                                          ? ssDeepPurpleLight
                                          : ssDeepPurpleDark,
                                  textColor: ssDeepPurpleLight,
                                ),
                              ),
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
      ManageEntityScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: _selectedEntityTabIndex == 1
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedEntityTabIndex = 0;
                  });
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            )
          : null,
      body: Container(
        color: Colors.grey[300],
        child: ViewEntity[_selectedEntityTabIndex],
      ),
    );
  }
}
