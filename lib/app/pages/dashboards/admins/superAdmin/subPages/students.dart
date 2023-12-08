import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../components/brandAssets/brandColors.dart';
import '../../../../../../global Widgets/splashScreen.dart';
import '../../../../../widgets/hoveButtonTextOnly.dart';

class Students extends StatefulWidget {
  const Students({super.key});

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Text('Student Dashboard')
          ],
        ),
      ),

    );
  }
}
