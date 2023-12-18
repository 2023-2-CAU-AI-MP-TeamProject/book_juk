import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Widget> bookcaseList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      addBookCase();
    }
  }

  void addBookCase() {
    setState(() {
      bookcaseList.add(BookShelf());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("임의로 설정한 타이틀", style: TextStyle(color: Colors.purpleAccent)),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 2.0,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
                  padding: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffC5965E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: bookcaseList,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBookCase,
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookShelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffC5965E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Row(),
    );
  }
}
