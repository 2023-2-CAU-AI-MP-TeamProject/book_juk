import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const TabBar(
        tabs: <Tab>[
          Tab(
            icon: Icon(Icons.home, size: 30),
            //text: "홈 화면"
          ),
          Tab(
            icon: Icon(Icons.search, size: 30),
            //text: "검색"
          ),
          Tab(
            icon: Icon(Icons.analytics, size: 30),
            //text: "통계"
          ),
          Tab(
            icon: Icon(Icons.settings, size: 30),
            //text: "설정"
          )
        ],
        labelColor: Colors.blue,
        unselectedLabelColor: Color.fromRGBO(20, 20, 20, 0.3),
        isScrollable: false,
        indicatorColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
      ),
    );
  }
}