import 'package:flutter/material.dart';
import 'dart:math';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Widget> bookcaseList = [];
  List<Widget> bookList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
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
      appBar: AppBar(
        title: Text("임의로 설정한 타이틀", style: TextStyle(color: Colors.purpleAccent)),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 2.0,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
                  padding: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffC5965E),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: bookcaseList,
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
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Book(),
          Book(),
          Book()
        ]
      ),
    );
  }
}

class Book extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final colors = [
      Theme.of(context).primaryColorLight,
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColorDark
    ];
    final random = Random();
    final bookColor = colors[random.nextInt(colors.length)];
    final bookHeight = 80 + random.nextInt(20);
    final bookTitle = "AI학과 화이팅";

    return GestureDetector(
      onTap: () {
        showDialog (context: context,
            builder: (context) {
          return AlertDialog(
            title: Text('책 제목'),
            content: Text('책 줄거리'),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('확인'))
            ],
          );
            },
        barrierDismissible: false);
      },
      child: Container(
        height: bookHeight.toDouble() - 0.5 * 2,
        width: 20 - 0.5 * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: bookColor,
          border: Border.all(color: Colors.black,
          width: 0.5)
        ),
        child: Center(
          heightFactor: bookHeight.toDouble() - 0.5 * 2,
          widthFactor: 20 - 0.5 * 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: bookTitle.split('').map((char) =>
                Text(char, style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold))).toList(),
          )),
      ),

    );
  }
}
