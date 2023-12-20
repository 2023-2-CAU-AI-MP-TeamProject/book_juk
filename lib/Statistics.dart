import 'package:book_juk/models/BookModel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'globals.dart' as globals;

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    Map<String, int> readBooksPerMonth = {};

    globals.books.forEach((book) {
      if (book.status == BookStatus.read) {
        String yearMonth = '${book.date.year}-${book.date.month}';
        readBooksPerMonth[yearMonth] = (readBooksPerMonth[yearMonth] ?? 0) + 1;
      }
    });

    readBooksPerMonth = Map.fromEntries(
      readBooksPerMonth.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    List<BarChartGroupData> barGroups = [];

    readBooksPerMonth.forEach((yearMonth, count) {
      List<String> yearMonthList = yearMonth.split('-');
      int year = int.parse(yearMonthList[0]);
      int month = int.parse(yearMonthList[1]);

      barGroups.add(
        BarChartGroupData(
          x: year * 12 + month.toInt(),
          barRods: [
            BarChartRodData(
              y: count.toDouble(),
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5)
              )
            ),
          ],
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('월별 통계'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('월별 독서 현황'),
            SizedBox(height: 10),
            Container(
              width: 300,
              height: 200,
              child: Builder(
                builder: (BuildContext context) {
                  if (barGroups.isEmpty) {
                    return Center(
                      child: Text('아직 저장된 책이 없습니다.'),
                    );
                  } else {
                    return Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: BarChart(
                      BarChartData(
                        barGroups: barGroups,
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTitles: (value) {
                              int combinedValue = value.toInt();
                              int month = (combinedValue - 1) % 12 + 1;
                              return '$month월';
                            },
                          ),
                          topTitles: SideTitles(showTitles: false),
                          leftTitles: SideTitles(showTitles: true),
                          rightTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    )
                    );
                  }
                },
              ),
            ),
            Text(
                '지금까지 총 ${readBooksPerMonth.isNotEmpty ? readBooksPerMonth.values.reduce((a, b) => a + b) : 0} 권 읽으셨어요!',
                style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
