import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class MyHome extends StatefulWidget {
  final TabController tabController;
  const MyHome({super.key, required this.tabController});

  @override
  State<MyHome> createState() => _MyHomeState();
}
class _MyHomeState extends State<MyHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            setState(() {
              globals.isSearchedViaHome = true;
              widget.tabController.index = 1;
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: IgnorePointer(
            ignoring: true,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                cursorColor: Colors.black54,
                decoration: const InputDecoration(
                  hintText: '도서 검색',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Home',
          style: TextStyle(
            fontSize: 100
          ),
          textAlign: TextAlign.center,
        )
      )
    );
  }
}