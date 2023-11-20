// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:book_juk/MyHome.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'Login.dart';
import 'Search.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initLoad();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

Future<bool> initLoad() async {
  bool data =false;

  KakaoSdk.init(nativeAppKey: '650492dd92ba874f33ebcb55c010e883');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  data = true;
  return data;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '책:크',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      routes: {
        '/': (context) => Landing(),
        '/search':(context) => Search()
      },
      debugShowCheckedModeBanner: false,
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

    List<Widget> navItems = [
      MyHome(),
      Search(),
      Login(),
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

