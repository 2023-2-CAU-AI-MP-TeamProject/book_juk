import 'package:flutter/material.dart';
import 'package:book_juk/utilities/Themes.dart';
import 'package:provider/provider.dart';
import 'package:book_juk/globals.dart' as globals;

class SettingColors extends StatefulWidget {
  const SettingColors({super.key});

  @override
  State<SettingColors> createState() => _SettingColorsState();
}

class _SettingColorsState extends State<SettingColors> {
  ThemeData selectedTheme = MyTheme.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테마 설정'),
        backgroundColor: Color(0xffDBE3E3),
      ),
      body: Container(
        color: Color(0xffDBE3E3),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 80,
                ),
                getColorButton(Colors.blue, MyTheme.blue),
                getColorButton(Colors.yellow, MyTheme.yellow),
                getColorButton(Colors.green, MyTheme.green),
                getColorButton(Colors.pink, MyTheme.pink),
                Container(
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      globals.navigatorKeys[globals.Screen.settings]!.currentState!.pop();
                    },
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getColorButton(Color color, ThemeData theme) {
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
