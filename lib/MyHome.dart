import 'package:flutter/material.dart';
import 'MyAppBar.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}
class _MyHomeState extends State<MyHome> {

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