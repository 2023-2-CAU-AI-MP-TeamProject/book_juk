import 'package:flutter/material.dart';
import 'MyAppBar.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Text('Home',
          style: TextStyle(
            fontSize: 100
          ),
          textAlign: TextAlign.center,
        )
      )
    );
  }
}