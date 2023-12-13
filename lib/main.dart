// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:book_juk/MyHome.dart';
import 'package:flutter/material.dart';
import 'Search.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'CustomNavigator.dart';
import 'MyTabBar.dart';
import 'Statistics.dart';
import 'setting.dart';
import 'package:flutter/material.dart';
import 'themes.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  runApp(MyApp(themeData:baseTheme));
  }

Future<bool> fetchData() async {
  bool data =false;

  await Future.delayed(const Duration(seconds: 3), () {data = true;});
  return data;
}

class MyApp extends StatelessWidget {
  final ThemeData themeData;
  const MyApp({super.key, required this.themeData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '책:크',
      theme: themeData,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   pageTransitionsTheme: PageTransitionsTheme(
      //     builders: {
      //       TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      //       TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      //     }
      //   )
      // ),
      routes: {
        '/': (context) => Landing(),
        '/search':(context) => Search(),
        '/statistics':(context) => Statistics(),
        '/setting':(context)=> Setting()
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
    Statistics(),
    Setting(),
  ];
  final _navigatorKeyList = List.generate(4, (index) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _pages.length,
      animationDuration: Duration.zero,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: _pages.map(
            (page) {
              int index = _pages.indexOf(page);
              return CustomNavigator(
                page: page,
                navigatorKey: _navigatorKeyList[index]
              );
            },
          ).toList()
        ),
        bottomNavigationBar: MyTabBar(),
      ),
    );
  }
}

