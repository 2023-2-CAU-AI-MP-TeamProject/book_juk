import 'package:flutter/material.dart';
import 'package:book_juk/setting/settingColors.dart';
import 'package:book_juk/setting/license.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:book_juk/globals.dart' as globals;

class Setting extends StatefulWidget {
  final Future<void> Function() logout;
  const Setting({super.key, required this.logout});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDBE3E3),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Color(0xffDBE3E3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Builder(builder: (context) {
                          final user = FirebaseAuth.instance.currentUser;
                          if(user != null){
                            final name = user.displayName;
                            final email = user.email;
                            final photoUrl = user.photoURL;
                            final uid = user.uid;
                            return Center(
                              child: Column(
                                children: [
                                  (photoUrl != null)
                                  ? ClipOval(child: Image.network(photoUrl, width: 200, height: 200, fit: BoxFit.cover,))
                                  : const FlutterLogo(),
                                  const SizedBox(height: 10),
                                  Text('$name',
                                    style: const TextStyle(
                                      fontSize: 20
                                    )
                                  ),
                                  Text('$email',
                                    style: const TextStyle(
                                      fontSize: 15
                                    )
                                  ),
                                  const SizedBox(height: 5),
                                  Text('uid: $uid',
                                    style: const TextStyle(
                                      fontSize: 10
                                    )
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Placeholder();
                        },),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text('유저 설정')
                    ),
                    borderLine(context),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _showInitializationDialog(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.grey),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: const Row(
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          globals.navigatorKeys[globals.Screen.settings]!.currentState!.push(
                            MaterialPageRoute(builder: (context) => const SettingColors()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.grey),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: const Row(
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
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.grey),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: const Row(
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
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text('기타')
                    ),
                    borderLine(context),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          globals.navigatorKeys[globals.Screen.settings]!.currentState!.push(
                            MaterialPageRoute(builder: (context) => License()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.grey),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: const Row(
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
            ),
          ),
        ],
      ),
    );

  }

  Widget borderLine(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
    );
  }

  void _showInitializationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xffDBE3E3),
          surfaceTintColor: Color(0xffDBE3E3),
          alignment: Alignment.bottomCenter,
          title: const Text(''),
          content: Container(
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('정말 초기화하시겠습니까?'),
                SizedBox(height: 10),
                Text('이 작업은 되돌릴 수 없습니다!!!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0
          ),
          titlePadding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                globals.navigatorKeys['root']!.currentState!.popUntil((route) => false,);
                globals.flush();
                await widget.logout();
                globals.navigatorKeys['root']!.currentState!.pushNamed('/');
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xffDBE3E3),
          surfaceTintColor: Color(0xffDBE3E3),
          alignment: Alignment.bottomCenter,
          title: const Text(''),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('정말 로그아웃하시겠습니까?'),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0
          ),
          titlePadding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                globals.navigatorKeys['root']!.currentState!.popUntil((route) => false,);
                await widget.logout();
                globals.navigatorKeys['root']!.currentState!.pushNamed('/');
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
