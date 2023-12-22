import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData theme = MyTheme.blue;

  void switchTheme(ThemeData selectedTheme) {
    theme = selectedTheme;
    notifyListeners();
  }
}
class MyTheme {
  static final ThemeData blue= ThemeData(
    primarySwatch: Colors.blue,
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.black12
    ),
    indicatorColor: Colors.transparent,
    // primaryColor: Color.fromARGB(255, 58, 67, 86),
    // primaryColorDark: Color.fromARGB(255, 0, 51, 153),
    // primaryColorLight: Color.fromARGB(255, 178, 204, 255),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }
    )
  );

  static final ThemeData yellow= ThemeData(
    primarySwatch: Colors.yellow,
    tabBarTheme: const TabBarTheme(
        labelColor: Colors.yellow,
        unselectedLabelColor: Colors.black12
    ),
    indicatorColor: Colors.transparent,
    // primaryColor: const Color.fromRGBO(255,228,0,255),
    // primaryColorDark: const Color.fromRGBO(250,237,125,255),
    // primaryColorLight: const Color.fromRGBO(242,203,97,255),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }
    )
  );

  static final ThemeData green= ThemeData(
    primarySwatch: Colors.green,
    tabBarTheme: const TabBarTheme(
        labelColor: Colors.green,
        unselectedLabelColor: Colors.black12
    ),
    indicatorColor: Colors.transparent,
    // primaryColor: const Color.fromRGBO(134,229,127,255),
    // primaryColorDark: const Color.fromRGBO(29,219,22,255),
    // primaryColorLight: const Color.fromRGBO(206,242,121,255),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }
    )
  );

  static final ThemeData pink= ThemeData(
    primarySwatch: Colors.pink,
    tabBarTheme: const TabBarTheme(
        labelColor: Colors.pink,
        unselectedLabelColor: Colors.black12
    ),
    indicatorColor: Colors.transparent,
    // primaryColor: const Color.fromRGBO(255,167,167,255),
    // primaryColorDark: const Color.fromRGBO(255,216,216,255),
    // primaryColorLight: const Color.fromRGBO(255,217,250,255),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }
    )
  );
}