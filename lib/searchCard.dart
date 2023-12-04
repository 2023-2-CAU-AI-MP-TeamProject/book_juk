// ignore_for_file: file_names, camel_case_types

import 'package:book_juk/models/BookModel.dart';
import 'package:flutter/material.dart';
import 'BookDetail.dart';
import 'package:html/parser.dart';

class searchCard extends StatelessWidget {
  final BookModel book;

  const searchCard(
    {Key? key,
    required this.book}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_decodeHtmlEntities(book.title), maxLines: 2, overflow: TextOverflow.ellipsis,),
      leading: Image.network(book.cover,
        width: 50,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_decodeHtmlEntities(book.author)),
          Text(_decodeHtmlEntities(book.description ?? '',),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.blue
            )
          )
        ]
      ),
      isThreeLine: true,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetail(isbn13: book.isbn13),));
      },
    );
  }
}

String _decodeHtmlEntities(String input) {
  final document = parse(input);
  final String parsedString = parse(document.body?.text).documentElement!.text;
  return parsedString;
}