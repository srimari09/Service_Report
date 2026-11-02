import 'package:flutter/material.dart';

import 'App_text.dart';
class Pagenotconnected extends StatefulWidget {
  const Pagenotconnected({super.key});

  @override
  State<Pagenotconnected> createState() => _PagenotconnectedState();
}

class _PagenotconnectedState extends State<Pagenotconnected> {
  @override
  Widget build(BuildContext context) {
    return pageIfNotConnected();
  }
}

Widget pageIfNotConnected() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.not_accessible, size: 65, color: Colors.redAccent),
          SizedBox(height: 15),
          AppText(
            text: 'Not connected, Try again Later',
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    ),
  );
}