import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'models/BookModel.dart';
import 'globals.dart' as globals;


class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int selectedYear = DateTime.now().year;
  int lastIntValue = -1;

  @override
  Widget build(BuildContext context) {
    Map<String, int> readBooksPerMonth = {};
    globals.books.forEach((book) {
      if (book.status == BookStatus.read && book.date.year == selectedYear) {
        String yearMonth = '${book.date.year}-${book.date.month}';
        readBooksPerMonth[yearMonth] = (readBooksPerMonth[yearMonth] ?? 0) + 1;
      }
    });
    readBooksPerMonth = Map.fromEntries(
      readBooksPerMonth.entries.toList()
        ..sort((a, b) {
          List<String> aList = a.key.split('-');
          List<String> bList = b.key.split('-');
          int aYear = int.parse(aList[0]);
          int aMonth = int.parse(aList[1]);
          int bYear = int.parse(bList[0]);
          int bMonth = int.parse(bList[1]);

          if (aYear != bYear) {
            return aYear.compareTo(bYear);
          } else {
            return aMonth.compareTo(bMonth);
          }
        }),
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
                topRight: Radius.circular(5),
              ),
              borderSide: BorderSide(
                width: 1
              ),
            ),
          ],
        ),
      );


    });

    return Scaffold(
      appBar: AppBar(
        title: Text('독서 통계'),
        actions: [
          DropdownButton<int>(
            value: selectedYear,
            items: List.generate(5, (index) {
              return DropdownMenuItem<int>(
                value: DateTime.now().year - index,
                child: Text((DateTime.now().year - index).toString(),
                  style: TextStyle(
                    color: Colors.black54,
                  ),),

              );
            }),
            onChanged: (value) {
              setState(() {
                selectedYear = value!;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 15),
                Text('  ${selectedYear} 독서 현황  ',
                  style: TextStyle(fontSize: 15),
                ),
                Icon(Icons.menu_book, size: 15,),
              ],
            ),
            SizedBox(height: 20),
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
                      child: BarChart(
                        BarChartData(
                          barGroups: barGroups,
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTitles: (value) {
                                int combinedValue = value.toInt();
                                //int year = (combinedValue - 1) ~/ 12 - 2000;
                                int month = (combinedValue - 1) % 12 + 1;
                                //return '${year.toString()}.${month.toString().padLeft(2, '0')}';
                                return '${month.toString().padLeft(2, '0')}';
                              },
                            ),
                            topTitles: SideTitles(showTitles: false),
                            leftTitles: SideTitles(showTitles: true,
                              getTitles: (value) {
                                int intValue = value.toInt();
                                if (lastIntValue != intValue) {
                                  lastIntValue = intValue;
                                  return intValue.toString();
                                } else {
                                  return '';
                                }
                              },),
                            rightTitles: SideTitles(showTitles: false),
                          ),
                          minY: 0,
                          maxY: readBooksPerMonth.isNotEmpty
                              ? readBooksPerMonth.values.reduce((a, b) => a > b ? a : b) + 1
                              : 0,
                        ),
                      ),

                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${selectedYear}년도에 총 ${readBooksPerMonth.isNotEmpty ? readBooksPerMonth.values.reduce((a, b) => a + b) : 0} 권 읽으셨어요! ',
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Icons.thumb_up_alt_outlined, size: 20),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
