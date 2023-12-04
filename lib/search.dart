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

class SearchState extends State<Search>{
  List<BookModel> searchedBooks = [];

  String input = '';
  final String ttb = 'ttbsdyhappy2211001';
  final TextEditingController tec = TextEditingController();

  int page = 1;
  final int booksPerPage = 10;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool _isFirstLoadRunning = false;
  late ScrollController _scrollController;

  final List<String> baseURL = [
    'https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=',
    '&Query=',
    '&QueryType=KeyWord&MaxResults=',
    '&start=',
    '&Output=JS&Version=20131101'
  ];

  @override
  void initState(){
    super.initState();
    _scrollController = ScrollController()..addListener(_nextLoad);
    _isFirstLoadRunning = false;
  }

  @override
  void dispose(){
    super.dispose();
    tec.dispose();
    _scrollController.dispose();
  }

  void initialize(){
    page = 1;
    _hasNextPage = true;
    _isLoadMoreRunning = false;
    _isFirstLoadRunning = false;
    searchedBooks.clear();
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
              Expanded(
                flex: 10,
                child: TextFormField(
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    hintText: '도서 검색',
                  ),
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: _onSubmitted,
                  controller: tec,
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _onSubmitted(tec.text);
                    },
                    icon: const Icon(Icons.search, color: Colors.black,)
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body()
    );
  }

  Widget body(){
    if(_isFirstLoadRunning && input !=''){
      return const Center(child: CircularProgressIndicator());
    }
    else if(input == ''){
      return GestureDetector(child: const Center(child: Text('검색어를 입력하세요.')));
    }
    else{
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: searchedBooks.length,
            itemBuilder: (context, idx) => searchCard(book: searchedBooks[idx]),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
        if(_isLoadMoreRunning == true)
        const Padding(
          padding: EdgeInsets.all(30),
          child: Center(child: CircularProgressIndicator())
        ),
        if(_hasNextPage == false)
        Container(
          padding: EdgeInsets.all(20),
          color: Colors.blue,
          child: const Center(child: Text('더 이상 검색결과가 없습니다.'),)
        )
      ],
    );
    }
  }

  void _onSubmitted(String value) async {
    initialize();
    setState(() {
      input = value;
      _isFirstLoadRunning = true;
    });
    await searchBook(page);
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {
    if(_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 1) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      page += 1;
      await searchBook(page);
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future<List<BookModel>> searchBook(int page) async {
    String URL = '${baseURL[0]}$ttb${baseURL[1]}$input${baseURL[2]}${booksPerPage.toString()}${baseURL[3]}${page.toString()}${baseURL[4]}';
    try {
      final Uri url = Uri.parse(URL);
      print('current URL: $URL');
      final response = await http.get(url);
      if(response.statusCode == 200) {
        List<dynamic> books = jsonDecode(response.body)['item'];
        if (books.isNotEmpty) {
          for (var book in books) {
            searchedBooks.add(BookModel.fromJson(book));
          }
          setState(() {});
        } else {
          _hasNextPage = false;
        }
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
    return searchedBooks;
  }


}