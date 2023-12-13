import 'package:flutter/material.dart';
import 'main.dart';
import 'Statistics.dart';
import 'settingColors.dart';

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
                ), // Adjust the radius as needed
              ),

              child: ElevatedButton(
                onPressed: () {
                  _showInitializationDialog(context);
                },

                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Text('초기화'),
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
                ), // Adjust the radius as needed
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingColors()));
                  //print('눌림');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
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
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },

                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Text('로그아웃'),
              ),
            ),
            SizedBox(height: 10),
            Text('라이선스 정보'),
          ],
        ),


      ),
    );
  }

  void _showInitializationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          //alignment: Alignment.bottomCenter, //이거 제대로 안됨...
          child: AlertDialog(
            title: Text(' '),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('정말 초기화하시겠습니까?'),
                SizedBox(height: 10),
                Text('이 작업은 되돌릴 수 없습니다!!!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 10.0),
            titlePadding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          //alignment: Alignment.bottomCenter, //이거 제대로 안됨...
          child: AlertDialog(
            title: Text(' '),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('정말 로그아웃하시겠습니까?'),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 10.0),
            titlePadding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      },
    );
  }
}
