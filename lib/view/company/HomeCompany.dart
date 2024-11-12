import 'package:flutter/material.dart';

class HomeCompany extends StatelessWidget {
  const HomeCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Iam Company",
          style: TextStyle(fontSize: 200),
        ),
      ),
    );
  }
}
