// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:book_juk/MyHome.dart';
import 'package:flutter/material.dart';
import 'Search.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'Statistics.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

Future<bool> fetchData() async {
  bool data =false;

  await Future.delayed(const Duration(seconds: 3), () {data = true;});
  return data;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '책:크',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
          }
        )
      ),
      routes: {
        '/': (context) => Landing(),
        '/search':(context) => Search(),
        '/statistics':(context) => Statistics()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  PageController pageController = PageController();

  final List<Widget> _pages = [
    MyHome(),
    Search(),
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
  final _navigatorKeyList = List.generate(4, (index) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    List<Widget> navItems = [
      MyHome(),
      Search(),
      Statistics(),
      Text(
        "SEEEEEEEEEETTTTTTTTTTTTTTTTTINGSSSSSSSSS!!!!!!!",
        style: TextStyle(
          fontSize: 100
        ),
        textAlign: TextAlign.center,
      )
    ];

    return Scaffold(
      body: navItems[_selectedIndex],
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

