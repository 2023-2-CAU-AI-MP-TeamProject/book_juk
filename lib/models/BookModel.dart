// ignore_for_file: file_names
import 'package:book_juk/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//알라딘 DB에서 받아온 정보들에 맞추어 변수를 설정하였다.
//담당: 이재인

enum BookStatus {
  read, unread
}
class BookModel {
  String title;
  String link;
  String author;
  String pubDate;
  String? description;
  String isbn;
  String isbn13;
  int itemId;
  // int priceSales;
  // int priceStandard;
  // String mallType;
  // String? stockStatus;
  // int mileage;
  String cover;
  // int categoryId;
  // String categoryName;
  String publisher;
  // int salesPoint;
  // bool adult;
  // bool fixedPrice;
  // int customerReviewRank;
  // dynamic subInfo;

  BookModel({
    required this.title,
    required this.link,
    required this.author,
    required this.pubDate,
    this.description,
    required this.isbn,
    required this.isbn13,
    required this.itemId,
    // required this.priceSales,
    // required this.priceStandard,
    // required this.mallType,
    // this.stockStatus,
    // required this.mileage,
    required this.cover,
    // required this.categoryId,
    // required this.categoryName,
    required this.publisher,
    // required this.salesPoint,
    // required this.adult,
    // required this.fixedPrice,
    // required this.customerReviewRank,
    // this.subInfo
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json["title"],
      link: json["link"],
      author: json["author"],
      pubDate: json["pubDate"],
      description: json["description"],
      isbn: json["isbn"],
      isbn13: json["isbn13"],
      itemId: json["itemId"],
      // priceSales: json["priceSales"],
      // priceStandard: json["priceStandard"],
      // mallType: json["mallType"],
      // stockStatus: json["stockStatus"],
      // mileage: json["mileage"],
      cover: json["cover"],
      // categoryId: json["categoryId"],
      // categoryName: json["categoryName"],
      publisher: json["publisher"],
      // salesPoint: json["salesPoint"],
      // adult: json["adult"],
      // fixedPrice: json["fixedPrice"],
      // customerReviewRank: json["customerReviewRank"],
      // subInfo: json["subInfo"]
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "link": link,
    "author": author,
    "pubDate": pubDate,
    "description": description,
    "isbn": isbn,
    "isbn13": isbn13,
    "itemId": itemId,
    "cover": cover,
    "publisher": publisher,
  };
}

class StoredBook extends BookModel{
  BookStatus status;
  DateTime date;
  bool isFavorite;

  StoredBook({
    required String title,
    required String link,
    required String author,
    required String pubDate,
    String? description,
    required String isbn,
    required String isbn13,
    required int itemId,
    required String cover,
    required String publisher,
    required this.status,
    required this.date,
    required this.isFavorite
  }) : super(
    title: title,
    link: link,
    author: author,
    pubDate: pubDate,
    description: description,
    isbn: isbn,
    isbn13: isbn13,
    itemId: itemId,
    cover: cover,
    publisher: publisher,
  );

  factory StoredBook.create(BookModel book, BookStatus status, DateTime date, bool isFavorite){
    return StoredBook(
      title: book.title,
      link: book.link,
      author: book.author,
      pubDate: book.pubDate,
      description: book.description,
      isbn: book.isbn,
      isbn13: book.isbn13,
      itemId: book.itemId,
      cover: book.cover,
      publisher: book.publisher,
      status: status,
      date: date,
      isFavorite: isFavorite
    );
  }

  @override
  factory StoredBook.fromJson(Map<String, dynamic> json) {
    return StoredBook(
      title: json["title"],
      link: json["link"],
      author: json["author"],
      pubDate: json["pubDate"],
      description: json["description"],
      isbn: json["isbn"],
      isbn13: json["isbn13"],
      itemId: json["itemId"],
      cover: json["cover"],
      publisher: json["publisher"],
      status: toEnum(json["status"]),
      date: DateTime.parse(json["date"].toDate().toString()),
      isFavorite: json["isFavorite"]
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    "title": title,
    "link": link,
    "author": author,
    "pubDate": pubDate,
    "description": description,
    "isbn": isbn,
    "isbn13": isbn13,
    "itemId": itemId,
    "cover": cover,
    "publisher": publisher,
    "status": status.toString(),
    "date": Timestamp.fromDate(date),
    "isFavorite": isFavorite
  };
}