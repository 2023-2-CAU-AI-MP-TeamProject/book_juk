import 'package:flutter/material.dart';
import 'main.dart';
import 'Statistics.dart';

class SettingColors extends StatelessWidget {

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
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),// Adjust the radius as needed
              ),

              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Statistics())); //임시
                  //print('눌림');
                },

                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Text(' '),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),// Adjust the radius as needed
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Statistics()));
                  //print('눌림');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Text(' '),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Statistics())); //임시
                  //print('눌림');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Text(' '),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Statistics())); //임시
                  //print('눌림');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Text(' '),
              ),
            ),
            SizedBox(height: 10),
            Text('확인'),
          ],
        ),


      ),
    );
  }
}