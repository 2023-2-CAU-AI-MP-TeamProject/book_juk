import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTabBar extends StatelessWidget {
  TabController tabController;

  MyTabBar({
    super.key,
    required this.tabController
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: TabBar(
        tabs: const <Tab>[
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
        unselectedLabelColor: const Color.fromRGBO(20, 20, 20, 0.3),
        isScrollable: false,
        indicatorColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
        controller: tabController,
      ),
    );
  }
}