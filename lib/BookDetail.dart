import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/BookModel.dart';
import 'MyAppBar.dart';

class BookDetail extends StatelessWidget {
  BookDetail(
    {super.key, 
    required this.isbn13}
  );
  final String ttb = 'ttbsdyhappy2211001';
  final String isbn13;
  final List<String> baseURL = [
    'http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=',
    '&itemIdType=',
    '&ItemID=',
    '&Output=JS&Cover=big&Version=20131101'
  ];

  final String itemIdType = 'isbn13';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
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
              BookModel book = snapshot.data;
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
                      child: Text(book.title,
                        style: const TextStyle(
                          fontSize: 30
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(book.author,
                        style: const TextStyle(
                          fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(book.description ?? '',)
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