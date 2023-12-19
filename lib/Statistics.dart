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
    Map<int, int> readBooksPerMonth = {};

    globals.books.forEach((book) {
      if (book.status == BookStatus.read) {
        int month = book.date.month;
        readBooksPerMonth[month] = (readBooksPerMonth[month] ?? 0) + 1;
      }
    });

    List<BarChartGroupData> barGroups = [];

    readBooksPerMonth.forEach((month, count) {
      barGroups.add(
        BarChartGroupData(
          x: month.toInt(),
          barRods: [
            BarChartRodData(
              y: count.toDouble(),
            ),
          ],
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('책 통계'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        int month = value.toInt();
                        if (readBooksPerMonth.containsKey(month)) {
                          return readBooksPerMonth[month].toString();
                        } else {
                          return '';
                        }
                      },
                    ),
                  ),

                ),
                //swapAnimationDuration: Duration(milliseconds: 150),
                //swapAnimationCurve: Curves.linear,
              ),
            ),
            Text(
              '지금까지 총 ${readBooksPerMonth.values.reduce((a, b) => a + b)}권 읽으셨어요!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
