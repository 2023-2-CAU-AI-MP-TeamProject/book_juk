class BookModel {
  final String version;
  final String logo;
  final String title;
  final String link;
  final String pubDate;
  final int totalResults;
  final int startIndex;
  final int itemsPerPage;
  final String query;
  final int searchCategoryId;
  final String searchCategoryName;
  final List<dynamic> item;

  BookModel({
    required this.version,
    required this.logo,
    required this.title,
    required this.link,
    required this.pubDate,
    required this.totalResults,
    required this.startIndex,
    required this.itemsPerPage,
    required this.query,
    required this.searchCategoryId,
    required this.searchCategoryName,
    required this.item
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      version: json["version"],
      logo: json["logo"],
      title: json["title"],
      link: json["link"],
      pubDate: json["pubDate"],
      totalResults: json["totalResults"],
      startIndex: json["startIndex"],
      itemsPerPage: json["itemsPerPage"],
      query: json["query"],
      searchCategoryId: json["searchCategoryId"],
      searchCategoryName: json["searchCategoryName"],
      item: json["item"]
    );
  }

}