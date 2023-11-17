// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'BookDetail.dart';
import 'package:html/parser.dart';

class searchCard extends StatelessWidget {
  final String title;
  final String author;
  final String? description;
  final String cover;
  final String isbn13;

  const searchCard(
    {Key? key,
    required this.title,
    required this.author,
    this.description,
    required this.cover,
    required this.isbn13}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_decodeHtmlEntities(title), maxLines: 2, overflow: TextOverflow.ellipsis,),
      leading: Image.network(cover,
        width: 50,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_decodeHtmlEntities(author)),
          Text(_decodeHtmlEntities(description ?? '',),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetail(isbn13: isbn13),));
      },
    );
  }
}

String _decodeHtmlEntities(String input) {
  final document = parse(input);
  final String parsedString = parse(document.body?.text).documentElement!.text;
  return parsedString;
}