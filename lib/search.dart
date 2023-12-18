import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/BookModel.dart';
import 'SearchCard.dart';

import 'globals.dart' as globals;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search>
with TickerProviderStateMixin{
  List<BookModel> searchedBooks = [];

  String input = '';
  final String ttb = 'ttbsdyhappy2211001';
  final TextEditingController tec = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  int page = 1;
  final int booksPerPage = 10;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool _isFirstLoadRunning = false;
  bool _isFilled = false;
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
    _scrollController = ScrollController()
    ..addListener(_nextLoad)
    ..addListener(() {
      if(_scrollController.position.userScrollDirection != ScrollDirection.idle){
        FocusScope.of(context).unfocus();
      }
    });
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

  void fullInitialize(){
    initialize();
    tec.clear();
    input = '';
    _isFilled = false;
    globals.isSearchedViaHome = false;
    globals.isAdded = false;
    globals.isFilled = _isFilled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            autofocus: true,
            focusNode: globals.focusNode,
            cursorColor: Colors.black54,
            decoration: InputDecoration(
              hintText: '도서 검색',
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none
              ),
              suffixIcon: (_isFilled) ? 
              IconButton(
                onPressed: () => setState(() {
                  tec.clear();
                  _isFilled = false;
                  globals.isFilled = _isFilled;
                  input = '';
                  FocusScope.of(context).requestFocus(globals.focusNode);
                }),
                icon: const Icon(CupertinoIcons.xmark_circle_fill, size: 20, color: Colors.black54,)
              ) : const SizedBox.shrink(),
              filled: true,
              fillColor: Colors.black12,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSubmitted,
            controller: tec,
            onChanged: (value) {
              setState(() {
                if(value == ''){_isFilled = false;}
                else{_isFilled = true;}
                globals.isFilled = _isFilled;
              });
            },
          ),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: body,
      backgroundColor: Colors.white,
    );
  }

  Widget get body{
    if(globals.isSearchedViaHome || globals.isAdded){
      setState(() {
        fullInitialize();
      });
    }
    if(_isFirstLoadRunning && input != ''){
      return const Center(child: CircularProgressIndicator());
    }
    else if(input == ''){
      return GestureDetector(
        onTap:() => FocusScope.of(context).unfocus(),
        onVerticalDragStart: (details) => FocusScope.of(context).unfocus(),
        onHorizontalDragStart: (details) => FocusScope.of(context).unfocus(),
        child: const SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: AbsorbPointer(
            absorbing: true,
            child: Center(
              child: Text('검색어를 입력하세요.')
            ),
          ),
        )
      );
    }
    else{
      return (searchedBooks.isEmpty) ? const Center(child: Text('검색 결과가 없습니다.'),) :
      SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(8.0),
              itemCount: searchedBooks.length,
              itemBuilder: (context, idx) => searchCard(
                book: searchedBooks[idx],
              ),
              separatorBuilder: (context, index) => const Divider(),
            ),
            if(_isLoadMoreRunning)
            Container(
              height: 70,
              padding: const EdgeInsets.all(10),
              child: const Center(child: CircularProgressIndicator())
            ),
            if(_hasNextPage == false && searchedBooks.isNotEmpty)
            Column(
              children: [
                const Divider(),
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  color: Colors.transparent,
                  child: const Center(child: Text('모든 결과를 검색했습니다.'),)
                ),
              ],
            )
          ],
        ),
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
    if(_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning && _scrollController.position.extentAfter < 50) {
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