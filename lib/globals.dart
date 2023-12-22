import 'package:flutter/material.dart';
import 'package:book_juk/models/BookModel.dart';
import 'package:book_juk/MyHome.dart';

enum Screen{
  home, search, statistics, settings
}

FocusNode focusNode = FocusNode();
bool isSearchedViaHome = false;
bool isAdded = false;
bool isFilled = false;

late TabController tabController;
final GlobalKey<BookShelfState> readBookShelfKey = GlobalKey<BookShelfState>();
final GlobalKey<BookShelfState> unreadBookShelfKey = GlobalKey<BookShelfState>();

List<StoredBook> books =[];

final navigatorKeys = {
  'root': GlobalKey<NavigatorState>(),
  Screen.home: GlobalKey<NavigatorState>(),
  Screen.search: GlobalKey<NavigatorState>(),
  Screen.statistics: GlobalKey<NavigatorState>(),
  Screen.settings: GlobalKey<NavigatorState>(),
};

void flush(){
  isSearchedViaHome = false;
  isAdded = false;
  isFilled = false;
  books.clear();
}

bool isInBookList(String isbn13){
  for(StoredBook book in books){
    if(book.isbn13 == isbn13) return true;
  }
  return false;
}