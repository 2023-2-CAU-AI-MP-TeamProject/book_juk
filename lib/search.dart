// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/BookModel.dart';
import 'searchCard.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  String input = '';
  final String baseURL1 = 'http://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey=';
  final String baseURL2 = '&QueryType=ItemNewAll&MaxResults=10&start=1&SearchTarget=Book&output=js&Version=20131101';
  final String TTB = 'ttbsdyhappy2211001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          child: TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Search Anything...',
              icon: Icon(Icons.search)
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSubmitted,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder(
          future: searchBook(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false){
              return CircularProgressIndicator();
            }
            else if (snapshot.hasError) {
              return Text('Error!');
            }
            else {
              return ListView.separated(
                padding: EdgeInsets.all(8.0),
                itemCount: 10,
                itemBuilder: (context, idx) {
                  BookModel book = snapshot.data[idx];
                  return searchCard(title: book.title, author: book.author, cover: book.cover, description: book.description);
                },
                separatorBuilder: (context, index) => Divider(),
              );
            }
          }
        ),
      )
    );
  }

  void _onSubmitted(String value) {
    setState(() {
      input = value;
    });
    searchBook();
  }

  Future<List<BookModel>> searchBook() async {
    List<BookModel> searchedBooks = [];

    final Uri url = Uri.parse('$baseURL1$TTB$baseURL2');
    final response = await http.get(url);

    if(response.statusCode == 200) {
      List<dynamic> books = jsonDecode(response.body)['item'];
      for (var book in books) {
        searchedBooks.add(BookModel.fromJson(book));
      }
      return searchedBooks;
    }
    throw Error();
  }
}