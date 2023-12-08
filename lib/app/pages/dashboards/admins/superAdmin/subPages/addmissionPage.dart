import 'package:flutter/material.dart';

class AddmissionPage extends StatefulWidget {
  const AddmissionPage({super.key});

  @override
  State<AddmissionPage> createState() => _AddmissionPageState();
}

class _AddmissionPageState extends State<AddmissionPage> {
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
              child: Text('Addmission Details'),

            ),
          ],
        ),
      ),
    );
  }
}
