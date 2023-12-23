import 'package:book_juk/globals.dart' as globals;
import 'package:book_juk/Login.dart';
import 'package:book_juk/models/BookModel.dart';
//상태를 변환하기 위한 switch문을 저장해둔 파일이다.
dynamic toEnum(dynamic value){
    if(value is int){
      switch(value){
        case 0:
          return globals.Screen.home;
        case 1:
          return globals.Screen.search;
        case 2:
          return globals.Screen.statistics;
        case 3:
          return globals.Screen.settings;
      }
      return globals.Screen.home;
    }
    else if(value is String){
      switch(value){
        case "LoginPlatform.kakao":
          return LoginPlatform.kakao;
        case "LoginPlatform.google":
          return LoginPlatform.google;
        case "LoginPlatform.none":
          return LoginPlatform.none;
        case "BookStatus.read":
          return BookStatus.read;
        case "BookStatus.unread":
          return BookStatus.unread;
      }
    }
    return value;
  }