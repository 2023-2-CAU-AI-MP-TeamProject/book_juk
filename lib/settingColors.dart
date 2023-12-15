import 'package:book_juk/MyHome.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'Statistics.dart';
import 'themes.dart';

class SettingColors extends StatefulWidget {
  @override
  _SettingColorsState createState() => _SettingColorsState();
}

class _SettingColorsState extends State<SettingColors> {
  ThemeData selectedTheme = baseTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테마 설정'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getColorButton(Colors.blue, baseTheme),
            SizedBox(height: 10),
            getColorButton(Colors.yellow, theme1),
            SizedBox(height: 10),
            getColorButton(Colors.green, theme2),
            SizedBox(height: 10),
            getColorButton(Colors.pink, theme3),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                onPrimary: Colors.black,
              ),
              onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyApp(themeData: selectedTheme),
                    ),
                  );
              },
              child: Text('확인'),
            ),

          ],
        ),
      ),
    );
  }

  Widget getColorButton(Color color, ThemeData theme) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedTheme = theme;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0
        ),
        child: Text(' '),
      ),
    );
  }
}
