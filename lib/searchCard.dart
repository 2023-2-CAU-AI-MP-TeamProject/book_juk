import 'package:flutter/material.dart';

class searchCard extends StatelessWidget {
  final String title;
  final String author;
  final String? description;
  final String cover;

  const searchCard(
    {Key? key,
    required this.title,
    required this.author,
    this.description,
    required this.cover}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Image.network(cover),
      subtitle: Text(author),
    );
  }
}