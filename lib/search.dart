// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  String input = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          cursorColor: Colors.black,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'hint'
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _onSubmitted,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(child: Text(input, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 100)))
    );
  }

  void _onSubmitted(String value) {
    setState(() {
      input = value;
    });
  }
}