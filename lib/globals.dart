import 'package:flutter/material.dart';
import 'models/BookModel.dart';

enum Screen{
  home, search, statistics, settings
}

FocusNode focusNode = FocusNode();
bool isSearchedViaHome = false;
bool isAdded = false;
bool isFilled = false;

late TabController tabController;

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