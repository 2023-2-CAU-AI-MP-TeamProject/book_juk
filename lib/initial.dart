//초기 화면

import 'package:flutter/material.dart';
import 'MyAppBar.dart';

class Initial extends StatefulWidget {
  const Initial({Key? key}) : super(key: key);

  @override
  State<Initial> createState() => _Initial();
}

class _Initial extends State<Initial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Container(
          width: 200,
          height: 40,
          color: Colors.blue,
        )
      ),
    );
  }
}
