import 'package:flutter/material.dart';

class License extends StatelessWidget {
  const License({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('라이선스 정보'),
        backgroundColor: Color(0xffDBE3E3),
      ),
      body: Container(
        color: Color(0xffDBE3E3),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '라이선스 정보',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '▶ 도서 정보',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '        알라딘 DB',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(width: 50.0),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      heightFactor: 0.48,
                      widthFactor: 0.48,
                      child: Image.asset(
                        'assets/icon.png',
                        width: 250.0,
                        height: 250.0,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '▶ 개발자 정보',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                '        서다연 (이메일@이메일.com)',
                style: TextStyle(fontSize: 16),
              ),
              Text('        이재인 (이메일@이메일.com)',
                style: TextStyle(fontSize: 16),),
              Text('        이정민 (이메일@이메일.com)',
                style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}
