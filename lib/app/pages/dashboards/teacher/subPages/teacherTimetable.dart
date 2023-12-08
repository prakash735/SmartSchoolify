import 'package:flutter/material.dart';

class TeacherTimeTable extends StatefulWidget {
  const TeacherTimeTable({super.key});

  @override
  State<TeacherTimeTable> createState() => _TeacherTimeTableState();
}

class _TeacherTimeTableState extends State<TeacherTimeTable> {
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
              child: Text('Teacher TimeTable'),

            ),
          ],
        ),
      ),

    );
  }
}
