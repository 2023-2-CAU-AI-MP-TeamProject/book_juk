import 'package:book_juk/BookStoreDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/BookModel.dart';
import 'package:html/parser.dart';

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
  late final BookModel book;

  void storeBook(BookStatus status, DateTime date) async {
    //todo : implement storing book via Firestore databases
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
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
                  if(states.contains(MaterialState.pressed)) {return Colors.blue;}
                  return Colors.black;
                }
              ),
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
              animationDuration: Duration.zero
            ),
            child: const Text('저장')
          )
        ],
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
        child: FutureBuilder(
          future: detailBook(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false){
              return const CircularProgressIndicator();
            }
            else if (snapshot.hasError) {
              return const Text('Error!');
            }
            else {
              book = snapshot.data;
              return SingleChildScrollView(
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
              );
            }
          }
        )
      )
    );
  }

  Future<BookModel> detailBook() async {
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