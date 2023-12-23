// ignore_for_file: file_names, camel_case_types

import 'dart:io';

import 'package:book_juk/models/BookModel.dart';
import 'package:flutter/material.dart';
import 'package:book_juk/detail/BookDetail.dart';
import 'package:html/parser.dart';


//search.dart에서 검색 기능을 구현하였는데, 검색 결과가 ListView 형식으로 나타나기 때문에
//그 안에 들어갈 ListTile을 구현하였다.
//담당: 이재인

class searchCard extends StatelessWidget {
  final BookModel book;

  const searchCard(
    {Key? key,
    required this.book
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_decodeHtmlEntities(book.title), maxLines: 2, overflow: TextOverflow.ellipsis,),
      leading: Builder(
        builder: (context) {
          try{
            return Image.network(book.cover,
              width: 50,
            );
          }catch(e){
            if(e is HttpException){
              return const FlutterLogo(size: 0.5);
            }
            else{
              throw e;
            }
          }
        },
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_decodeHtmlEntities(book.author),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(_decodeHtmlEntities(book.description ?? '',),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary
            )
          )
        ]
      ),
      isThreeLine: true,
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookDetail(isbn13: book.isbn13),));
      },
    );
  }
}

String _decodeHtmlEntities(String input) {
  final document = parse(input);
  final String parsedString = parse(document.body?.text).documentElement!.text;
  return parsedString;
}