import 'dart:math';
import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Widget> bookcaseList = [];
  Matrix4 _transformationMatrix = Matrix4.identity();
  double _scale = 1.0;
  late Offset _previousOffset;
  Offset _currentOffset = Offset.zero;
  late double _previousScale;

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
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
        _previousOffset = details.focalPoint;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          double newScale = _previousScale * details.scale;
          _scale = max(1.0, newScale);
          _currentOffset = details.focalPoint;
          _transformationMatrix = Matrix4.identity()
            ..translate(_currentOffset.dx - _previousOffset.dx, _currentOffset.dy - _previousOffset.dy)
            ..scale(_scale, _scale, 1);
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        if (_scale == 1.0) {
          setState(() {
            _transformationMatrix = Matrix4.identity();
            _previousOffset = Offset.zero;
          });
        }
        _previousScale = _scale;
        _previousOffset = _currentOffset;
      },
      child: Transform(
        transform: _transformationMatrix,
        alignment: FractionalOffset.center,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                ),
                child: Text(
                  "여기는 검색",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
                child: Text(
                  "읽은 책 / 읽고 싶은 책",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
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
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: addBookCase,
            child: Icon(Icons.add),
          ),
        ),
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
