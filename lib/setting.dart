import 'package:flutter/material.dart';
import 'main.dart';
import 'Statistics.dart';
import 'settingColors.dart';
import 'license.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('     유저 설정'),
            Container(
              margin: EdgeInsets.all(10),
              width: 400,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _showInitializationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                    elevation: 0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text('초기화',
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingColors()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                    elevation: 0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.palette,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text('테마 설정',
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.door_back_door,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text('로그아웃',
                      style: TextStyle(
                      color: Colors.black,
                    ),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Text('     기타'),
            Container(
              margin: EdgeInsets.all(10),
              width: 400,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => License()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                    elevation: 0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text('라이선스 정보',
                      style: TextStyle(
                      color: Colors.black,

                    ),),
                  ],
                ),
              ),
            ),
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
