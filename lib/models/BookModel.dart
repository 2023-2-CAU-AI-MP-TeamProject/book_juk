class BookModel {
  String title;
  String link;
  String author;
  String pubDate;
  String? description;
  String isbn;
  String isbn13;
  int itemId;
  int priceSales;
  int priceStandard;
  String mallType;
  String? stockStatus;
  int mileage;
  String cover;
  int categoryId;
  String categoryName;
  String publisher;
  int salesPoint;
  bool adult;
  bool fixedPrice;
  int customerReviewRank;
  dynamic subInfo;

  BookModel({
    required this.title,
    required this.link,
    required this.author,
    required this.pubDate,
    this.description,
    required this.isbn,
    required this.isbn13,
    required this.itemId,
    required this.priceSales,
    required this.priceStandard,
    required this.mallType,
    this.stockStatus,
    required this.mileage,
    required this.cover,
    required this.categoryId,
    required this.categoryName,
    required this.publisher,
    required this.salesPoint,
    required this.adult,
    required this.fixedPrice,
    required this.customerReviewRank,
    this.subInfo
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
      priceSales: json["priceSales"],
      priceStandard: json["priceStandard"],
      mallType: json["mallType"],
      stockStatus: json["stockStatus"],
      mileage: json["mileage"],
      cover: json["cover"],
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      publisher: json["publisher"],
      salesPoint: json["salesPoint"],
      adult: json["adult"],
      fixedPrice: json["fixedPrice"],
      customerReviewRank: json["customerReviewRank"],
      subInfo: json["subInfo"]
    );
  }

}