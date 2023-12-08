import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentAttendence extends StatefulWidget {
  const StudentAttendence({super.key});

  @override
  State<StudentAttendence> createState() => _StudentAttendenceState();
}

class _StudentAttendenceState extends State<StudentAttendence> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('Students Attendence'),

            ),
          ],
        ),
      ),

    );
  }
}
