import 'package:flutter/material.dart';

class License extends StatelessWidget {
  const License({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('라이선스 정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '라이선스 정보',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '▶ 도서 정보: 알라딘 DB',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  '▶ 개발자 정보: ~~~',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(width: 50.0),
            Image.asset(
              'assets/icon.png',
              width: 100.0,
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }
}
