// ignore_for_file: must_be_immutable

import 'package:book_juk/detail/BookStoreDialog.dart';
import 'package:book_juk/firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:book_juk/models/BookModel.dart';
import 'package:html/parser.dart';
import 'package:book_juk/globals.dart' as globals;

class BookDetail extends StatelessWidget {
  BookDetail(
    {super.key, 
    required this.isbn13}
  );
  final String ttb = 'ttbsdyhappy2211001';
  final String isbn13;
  final List<String> baseURL = [
    'https://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=',
    '&itemIdType=',
    '&ItemID=',
    '&Output=JS&Cover=big&Version=20131101'
  ];

  final String itemIdType = 'isbn13';
  final FireStoreService firestore = FireStoreService();
  late BookModel book;

  void storeBook(BookStatus status, DateTime date) {
    final b = StoredBook.create(book, status, date);
    globals.books.add(b);
    firestore.storeBook(b);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadBook(),
      builder:(context, snapshot) {
        if(!snapshot.hasData){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            )
          );
        }
        else if(snapshot.hasError){
          return const Scaffold(
            body: Center(
              child: Text('Error!')
            )
          );
        }
        else{
          book = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              actions: (!globals.isInBookList(isbn13))
              ? <Widget>[
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => BookStoreDialog(callBackBook: storeBook),
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if(states.contains(MaterialState.pressed)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        return Colors.black;
                      }
                    ),
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                    animationDuration: Duration.zero
                  ),
                  child: const Text('저장')
                )
              ]
              : [],
              leading: BackButton(
                onPressed: () => Navigator.pop(context),
                // splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                // icon: const Icon(CupertinoIcons.back, color: Colors.black),
                color: Colors.black
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.network(book.cover,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_decodeHtmlEntities(book.title),
                        style: const TextStyle(
                          fontSize: 30
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_decodeHtmlEntities(book.author),
                        style: const TextStyle(
                          fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_decodeHtmlEntities(book.description ?? ''))
                    )
                  ],
                ),
              )
            )
          );
        }
      },
    );
  }

  Future<BookModel> loadBook() async {
    List<dynamic> searchedBook;

    final Uri url = Uri.parse('${baseURL[0]}$ttb${baseURL[1]}$itemIdType${baseURL[2]}$isbn13${baseURL[3]}');
    final response = await http.get(url);

    if(response.statusCode == 200) {
      searchedBook = jsonDecode(response.body)['item'];
      return BookModel.fromJson(searchedBook[0]);
    }
    throw Error();
  }
}

String _decodeHtmlEntities(String input) {
  final document = parse(input);
  final String parsedString = parse(document.body?.text).documentElement!.text;
  return parsedString;
}