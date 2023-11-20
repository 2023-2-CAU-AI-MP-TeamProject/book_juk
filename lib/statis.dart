import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Statis extends StatelessWidget { //이건 책 저장되는 것 구현한 후에 수정하기. 일단 예시로 써뒀음.
  final List<Book> savedBooks = [
    Book('1월', '제목 1'),
    Book('1월', '제목 2'),
    Book('2월','제목 2')
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('책 통계'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300, // 원하는 폭으로 조절
                height: 200, // 원하는 높이로 조절
                child: _buildHistogram(),
              ),
              Text(
                '지금까지 총 ' + savedBooks.length.toString() + '권 읽으셨어요!',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistogram() {
    Map<String, int> bookCounts = {};
    for (var book in savedBooks) {
      bookCounts[book.month] = (bookCounts[book.month] ?? 0) + 1;
    }

    List<charts.Series<Book, String>> seriesList = [
      charts.Series<Book, String>(
        id: 'Books',
        domainFn: (Book book, _) => book.month,
        measureFn: (Book book, _) => bookCounts[book.month],
        data: savedBooks,
      ),
    ];

    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
      behaviors: [charts.SeriesLegend()],
      defaultRenderer: charts.BarRendererConfig(
        //cornerStrategy: const charts.ConstCornerStrategy(30), // 차트의 모서리 라운딩 설정
      ),
    );
  }
}

class Book { //이것도 저장하는 거 구현한 후에 수정해야 할듯.
  String month;
  String title;

  Book(this.month, this.title);
}

void main() {
  runApp(Statis());
}
