import 'package:flutter/material.dart';
//App의 Appbar다.
//담당: 이재인
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: const Text('책:크 - 나만의 책꽂이'),
      leading: const Icon(Icons.book_rounded),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(50);
}