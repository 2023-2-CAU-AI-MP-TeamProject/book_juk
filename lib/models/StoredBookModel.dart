import 'BookModel.dart';

enum BookStatus {
  read, unread
}

class StoredBook extends BookModel {
  BookStatus status;
  DateTime readDate;

  StoredBook({
    required this.status,
    required this.readDate,
    required super.title,
    required super.link,
    required super.author,
    required super.pubDate,
    super.description,
    required super.isbn,
    required super.isbn13,
    required super.itemId,
    required super.cover,
    required super.publisher,
  });
}