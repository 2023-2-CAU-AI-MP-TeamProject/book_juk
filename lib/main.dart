// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:book_juk/MyHome.dart';
import 'package:flutter/material.dart';
import 'Search.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'CustomNavigator.dart';
import 'Statistics.dart';

import 'globals.dart' as globals;

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
        '/': (context) => Landing()
      },
      navigatorKey: globals.navigatorKeys['root'],
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing>
with SingleTickerProviderStateMixin {

  DateTime? currentBackPressTime;
  globals.Screen _selectedScreen = globals.Screen.home;
  final Map<Object, GlobalKey<NavigatorState>> _navigatorKeyList = globals.navigatorKeys;
  late TabController tabController;

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("현재 index: $_selectedScreen\n '뒤로' 버튼 한번 더 눌러 종료"),
        duration: Duration(seconds: 2),
      )
    );
  }

  globals.Screen indexToEnum(int index){
    switch(index){
      case 0:
        return globals.Screen.home;
      case 1:
       return globals.Screen.search;
      case 2:
        return globals.Screen.statistics;
      case 3:
        return globals.Screen.settings;
    }
    return globals.Screen.home;
  }

  @override
  void initState() {
    globals.tabController = TabController(
      length: 4,
      vsync: this,
      animationDuration: Duration.zero
    );
    tabController = globals.tabController;
    tabController.addListener(() {
      if(tabController.index == 1 && tabController.previousIndex != 1){
        setState(() {
          FocusScope.of(context).requestFocus(globals.focusNode);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MyHome(tabController: tabController),
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
    return WillPopScope(
      onWillPop: () async {
        if(await _navigatorKeyList[_selectedScreen]!.currentState!.maybePop()){
          return Future.value(false);
        } else {
          DateTime now = DateTime.now();
          if(currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)){
            currentBackPressTime = now;
            showSnackBar();
            return Future.value(false);
          }
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: pages.map(
            (page) {
              globals.Screen screen = indexToEnum(pages.indexOf(page));
              return CustomNavigator(
                page: page,
                navigatorKey: _navigatorKeyList[screen]!,
              );
            },
          ).toList()
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: TabBar(
            tabs: const <Tab>[
              Tab(
                icon: Icon(Icons.home, size: 30),
                //text: "홈 화면"
              ),
              Tab(
                icon: Icon(Icons.search, size: 30),
                //text: "검색"
              ),
              Tab(
                icon: Icon(Icons.analytics, size: 30),
                //text: "통계"
              ),
              Tab(
                icon: Icon(Icons.settings, size: 30),
                //text: "설정"
              )
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: const Color.fromRGBO(20, 20, 20, 0.3),
            isScrollable: false,
            indicatorColor: Colors.transparent,
            tabAlignment: TabAlignment.fill,
            controller: tabController,
            onTap: (value) => setState(() {
              _selectedScreen = indexToEnum(value);
            }),
          ),
        )
      ),
    );
  }
}