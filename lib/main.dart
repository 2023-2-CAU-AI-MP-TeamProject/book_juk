// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Programming Team Project',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      routes: {
        '/': (context) => Landing(),
      }
    );
  }
}

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _MyLanding();
}

class _MyLanding extends State<Landing> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    List<Text> texts = [
      Text(
        "Book-Juk!!",
        style: TextStyle(
          fontSize: 100
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        "Search!!!!!!",
        style: TextStyle(
          fontSize: 100
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        "Analytics!!!!!!!!!!!!!!",
        style: TextStyle(
          fontSize: 100
        ),
        textAlign: TextAlign.center,
      ),
      Text(
        "SEEEEEEEEEETTTTTTTTTTTTTTTTTINGSSSSSSSSS!!!!!!!",
        style: TextStyle(
          fontSize: 100
        ),
        textAlign: TextAlign.center,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Book-Juk"),
        leading: Icon(Icons.book),
      ),
      body: Align(
        alignment: Alignment.center,
        child: texts[_selectedIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "홈 화면"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "검색"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "통계"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "설정"
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped
      ),
    );
  }
}