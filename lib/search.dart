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
  final int booksPerPage = 10;
  final String ttb = 'ttbsdyhappy2211001';
  final TextEditingController tec = TextEditingController();
  int page = 1;
  bool isSubmitted = false;

  final List<String> baseURL = [
    'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=',
    '&Query=',
    '&QueryType=KeyWord&MaxResults=',
    '&start=',
    '&Output=JS&Version=20131101'
  ];

  @override
  void initState(){
    super.initState();
    isSubmitted = false;
  }

  @override
  void dispose(){
    super.dispose();
    tec.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    hintText: '도서 검색',
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: _onSubmitted,
                  controller: tec,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _onSubmitted(tec.text);
                  },
                  icon: const Icon(Icons.search, color: Colors.black,)
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap:() {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: (isSubmitted && input !='') ? FutureBuilder(
            future: searchBook(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData == false){
                isSubmitted = false;
                return const CircularProgressIndicator();
              }
              else if (snapshot.hasError) {
                isSubmitted = false;
                return const Text('Error!');
              }
              else if (snapshot.data.length == 0) {
                isSubmitted = false;
                return const Text('검색 결과가 없습니다.',
                  style: TextStyle(fontSize: 20)
                );
              }
              else {
                isSubmitted = false;
                return ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: (snapshot.data.length >= 10) ? 10 : snapshot.data.length,
                  itemBuilder: (context, idx) {
                    BookModel book = snapshot.data[idx];
                    return searchCard(
                      title: book.title,
                      author: book.author,
                      cover: book.cover,
                      description: book.description,
                      isbn13: book.isbn13,
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                );
              }
            }
          ) : 
          Container()
        ),
      )
    );
  }

  void _onSubmitted(String value) {
    setState(() {
      input = value;
      isSubmitted = true;
    });
  }

  Future<List<BookModel>> searchBook() async {
    List<BookModel> searchedBooks = [];

    final Uri url = Uri.parse(
      '${baseURL[0]}$ttb${baseURL[1]}$input${baseURL[2]}${booksPerPage.toString()}${baseURL[3]}${page.toString()}${baseURL[4]}'
    );
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