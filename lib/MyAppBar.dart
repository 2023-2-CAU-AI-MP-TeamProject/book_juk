import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context){
    return AppBar(
      title: Text('책:크 - 나만의 책꽂이'),
      leading: Icon(Icons.book_rounded),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(50);
}