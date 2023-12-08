import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentCertificate extends StatefulWidget {
  const StudentCertificate({super.key});

  @override
  State<StudentCertificate> createState() => _StudentCertificateState();
}

class _StudentCertificateState extends State<StudentCertificate> {
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
              child: Text('Students Certificate'),

            ),
          ],
        ),
      ),

    );
  }
}
