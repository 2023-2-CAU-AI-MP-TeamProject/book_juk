import 'package:flutter/material.dart';
import 'main.dart';
import 'Statistics.dart';

class Setting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),// Adjust the radius as needed
              ),

              child: Center(
                child: Text(
                  '초기화',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black12,
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
                child: Text('테마 설정'),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('라이선스 정보'),
          ],
        ),


      ),
    );
  }
}