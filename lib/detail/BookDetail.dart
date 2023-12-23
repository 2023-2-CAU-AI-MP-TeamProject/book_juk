// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'package:book_juk/detail/BookStoreDialog.dart';
import 'package:book_juk/firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:book_juk/models/BookModel.dart';
import 'package:html/parser.dart';
import 'package:book_juk/globals.dart' as globals;

//책에 대한 상세 정보를 다루는 파일이다.
//MyHome.dart에서 구현한 책장에서 책을 눌러 상세보기를 누르거나, 검색창에서 책을 검색해서 정보를 볼 때, 해당 페이지를 출력한다.
//책에 대한 정보를 알라딘DB에서 가져오도록 한다.
//담당: 이재인

class BookDetail extends StatefulWidget {
  final String isbn13;
  late StoredBook? storedBook;
  BookDetail(
    {super.key, 
    required this.isbn13,
    this.storedBook}
  );

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  
  final String ttb = 'ttbsdyhappy2211001';
  final List<String> baseURL = [
    'https://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=',
    '&itemIdType=',
    '&ItemID=',
    '&Output=JS&Cover=big&Version=20131101'
  ];
  final String itemIdType = 'isbn13';
  final FireStoreService firestore = FireStoreService();
  late BookModel book;
  
  void storeBook(BookStatus status, DateTime date, bool isFavorite) {
    final b = StoredBook.create(book, status, date, isFavorite);
    if(globals.isInBookList(widget.isbn13)) {
      globals.deleteBookInList(widget.isbn13);
      globals.books.add(b);
      print(globals.books.length);
    }else {
      () {
        globals.books.add(b);
      };
    }
    firestore.storeBook(b);
    globals.navigatorKeys['root']!.currentState!.setState(() {});
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
              actions: (!globals.isInBookList(widget.isbn13))
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
              : <Widget>[
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => BookStoreDialog(callBackBook: storeBook, book: widget.storedBook),
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
                  child: const Text('수정')
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('정말 이 책을 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('취소',
                              style: TextStyle(color: Colors.black)
                            )
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              globals.books.remove(widget.storedBook!);
                              firestore.deleteBook(widget.storedBook!);
                              globals.navigatorKeys['root']!.currentState!.setState(() {});
                              if(globals.navigatorKeys[globals.Screen.home]!.currentState != null){
                                globals.navigatorKeys[globals.Screen.home]!.currentState!.setState(() {});
                                globals.navigatorKeys[globals.Screen.home]!.currentState!.pop();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("정상적으로 삭제가 완료되었습니다."),
                                duration: Duration(seconds: 1)
                              ));
                            },
                            child: const Text('삭제', 
                              style: TextStyle(color: Colors.red)
                            )
                          ),
                        ],
                      ),
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
                  child: const Text('삭제')
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

    final Uri url = Uri.parse('${baseURL[0]}$ttb${baseURL[1]}$itemIdType${baseURL[2]}${widget.isbn13}${baseURL[3]}');
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