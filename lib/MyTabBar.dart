import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTabBar extends StatelessWidget {
  TabController tabController;
  Function onTap;

  MyTabBar({
    super.key,
    required this.tabController,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}