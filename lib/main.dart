// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:flutter/material.dart';

import 'package:book_juk/MyHome.dart';
import 'package:book_juk/Login.dart';
import 'package:book_juk/search/Search.dart';
import 'package:book_juk/firebase/firebase_options.dart';
import 'package:book_juk/firebase/firestore.dart';
import 'package:book_juk/utilities/CustomNavigator.dart';
import 'package:book_juk/Statistics.dart';
import 'package:book_juk/setting/Setting.dart';
import 'package:book_juk/utilities/Themes.dart';
import 'package:book_juk/utilities/utilities.dart';
import 'package:book_juk/setting/settingColors.dart';
import 'package:book_juk/globals.dart' as globals;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  if(!(await initLoad())) {
    throw Error();
  }
  FlutterNativeSplash.remove();
  runApp(MyApp());
}

Future<bool> initLoad() async {
  bool data = false;

  KakaoSdk.init(
    nativeAppKey: '650492dd92ba874f33ebcb55c010e883',
    javaScriptAppKey: 'afa87686307e58f3967f15ac07b60253'
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  data = true;
  return data;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => ThemeProvider(),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: '책:크',
          theme: themeProvider.theme,
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
      },
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
  LoginPlatform _loginPlatform = LoginPlatform.none;
  Future? _loading;
  final double tabHeight = 72;

  final FireStoreService firestore = FireStoreService();

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("'뒤로' 버튼 한번 더 눌러 종료"),
        duration: Duration(seconds: 2),
      )
    );
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
      setState(() {});
      if(tabController.index == 1 && tabController.previousIndex != 1 && !globals.isFilled){
        setState(() {
          final temp = globals.navigatorKeys[globals.Screen.search]!.currentState;
          if(temp != null && !temp.canPop()){
            FocusScope.of(context).requestFocus(globals.focusNode);
          }
        });
      }
    });
    getTheme(context).then((value) {});
    _loading = getLoginInfo().then((_) {
      if(_loginPlatform != LoginPlatform.none){
        firestore.initOrUpdateFireStore();
        firestore.loadBooks().then((books) => setState(() {globals.books = books;}));
      }
    });
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    tabController.dispose();
  }

  Future<void> getTheme(BuildContext context) async {
      final pref = await SharedPreferences.getInstance();
      ThemeData? theme = themeFromString(await pref.getString('theme') ?? '');
      if(theme != null && context.mounted){
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.switchTheme(theme);
      }
  }

  Future<void> getLoginInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _loginPlatform = toEnum(pref.getString("login_platform")) ?? LoginPlatform.none;
    print('end: $_loginPlatform');
    setState(() {});
    return;
  }

  Future<void> setLoginState(LoginPlatform loginPlatform) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString("login_platform", loginPlatform.toString());
    });
    return;
  }

  Future<void> signOut() async {
    switch(_loginPlatform){
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        await FirebaseAuth.instance.signOut();
        break;
      case LoginPlatform.google:
        await FirebaseAuth.instance.signOut();
        break;
      case LoginPlatform.none:
        if(context.mounted){
          const SnackBar sb = SnackBar(
            content: Text('Error: Already logoutted.'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(sb);
          return;
        }
    }
    _loginPlatform = LoginPlatform.none;
    setLoginState(_loginPlatform);
    print('로그아웃됨');
  }

  void showLoading(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator()
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MyHome(tabController: tabController, loginPlatform: _loginPlatform),
      Search(),
      Statistics(),
      Setting(logout: signOut)
    ];

    if(_loginPlatform == LoginPlatform.none) {
      return FutureBuilder<dynamic>(
        future: _loading,
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            default:
              return Login();
          }
        },
      );
    }
    else{
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
                globals.Screen screen = toEnum(pages.indexOf(page));
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
              tabs: <Tab>[
                Tab(
                  icon: Icon(Icons.home, size: 30),
                  height: tabHeight,
                  //text: "홈 화면"
                ),
                Tab(
                  icon: Icon(Icons.search, size: 30),
                  height: tabHeight,
                  //text: "검색"
                ),
                Tab(
                  icon: Icon(Icons.analytics, size: 30),
                  height: tabHeight,
                  //text: "통계"
                ),
                Tab(
                  icon: Icon(Icons.settings, size: 30),
                  height: tabHeight,
                  //text: "설정"
                )
              ],
              isScrollable: false,
              indicatorColor: Colors.transparent,
              tabAlignment: TabAlignment.fill,
              controller: tabController,
              onTap: (value) => setState(() {
                _selectedScreen = toEnum(value);
              }),
            ),
          )
        ),
      );
    }
  }
}
