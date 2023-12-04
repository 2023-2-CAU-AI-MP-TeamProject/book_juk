import 'dart:math';

import 'package:flutter/material.dart';
import 'MyAppBar.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}
class _MyHomeState extends State<MyHome> {
  List<Widget> bookcaseList = [];
  double _initialScale = 1.0;
  double _scaleFactor = 1.0;
  double _rotation = 1.0;

  @override
  void initState() {
    super.initState();
    for(int i = 0; i<5; i++) {
      addBookCase();
    }
  }

  void addBookCase() {
    setState(() {
      bookcaseList.add(BookShelf());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.purpleAccent
            ),
            child: Text("여기는 검색", textAlign: TextAlign.center,),
          ),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.purple
            ),
            child: Text("읽은 책 / 읽고 싶은 책", textAlign: TextAlign.center,),
          ),
          Expanded(
            child: GestureDetector(
              onScaleStart: (details) {
                setState(() {
                  _initialScale = _scaleFactor;
                });
              },
              onScaleUpdate: (details) {
                setState(() {
                  _scaleFactor = _initialScale * details.scale;
                });
              },
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
                    padding: EdgeInsets.only(bottom: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xffC5965E),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: bookcaseList
                    ),
                  ),
                ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBookCase,
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookShelf extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xffC5965E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
      child: Row(),
    );
  }
}
