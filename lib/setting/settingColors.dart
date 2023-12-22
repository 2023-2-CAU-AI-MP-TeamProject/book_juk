import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_juk/utilities/Themes.dart';
import 'package:provider/provider.dart';
import 'package:book_juk/globals.dart' as globals;

ThemeData? themeFromString(String value){
  switch(value){
    case 'blue':
      return MyTheme.blue;
    case 'yellow':
      return MyTheme.yellow;
    case 'pink':
      return MyTheme.pink;
    case 'green':
      return MyTheme.green;
  }
  return null;
}

class SettingColors extends StatefulWidget {
  const SettingColors({super.key});

  @override
  State<SettingColors> createState() => _SettingColorsState();
}

class _SettingColorsState extends State<SettingColors> {
  ThemeData selectedTheme = MyTheme.blue;
  String stringTheme = 'blue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테마 설정'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getColorButton(Colors.blue, MyTheme.blue, 'blue'),
              getColorButton(Colors.yellow, MyTheme.yellow, 'yellow'),
              getColorButton(Colors.green, MyTheme.green, 'green'),
              getColorButton(Colors.pink, MyTheme.pink, 'pink'),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  globals.navigatorKeys[globals.Screen.settings]!.currentState!.pop();
                  final pref = await SharedPreferences.getInstance();
                  await pref.setString('theme', stringTheme);
                },
                child: const Text('확인'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget getColorButton(Color color, ThemeData theme, String value) {
    return Container(
      width: 300,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final provider = Provider.of<ThemeProvider>(context, listen: false);
            provider.switchTheme(theme);
          },
          child: Container(),
        ),
      ),
    );
  }
}
