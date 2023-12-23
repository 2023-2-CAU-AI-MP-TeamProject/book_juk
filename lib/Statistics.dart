import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'models/BookModel.dart';
import 'globals.dart' as globals;
//fl_chart를 이용하여 년도별, 월별로 읽은 책의 권수를 통계내준다.
//담당: 서다연, 보조: 이정민
class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int selectedYear = DateTime.now().year;
  int lastIntValue = -1;

  @override
  Widget build(BuildContext context) { //BookStatus.read를 이용해서 읽은 책의 권수를 가져와서 통계를 낸다.
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

    List<BarChartGroupData> barGroups = []; // 년도와 월을 기준으로 책을 분류한다.
    readBooksPerMonth.forEach((yearMonth, count) {
      List<String> yearMonthList = yearMonth.split('-');
      int year = int.parse(yearMonthList[0]);
      int month = int.parse(yearMonthList[1]);

      int totalBars=readBooksPerMonth.length; //차트 바에 읽은 권수를 표현한다.
      double barWidth = MediaQuery.of(context).size.width * 0.8/totalBars;
      double maxBarWidth = MediaQuery.of(context).size.width * 0.3;
      barWidth = barWidth > maxBarWidth ? maxBarWidth : barWidth;

      barGroups.add( //차트 바의 디자인을 조정한다.
        BarChartGroupData(
          x: year * 12 + month.toInt(),
          barRods: [
            BarChartRodData(
              y: count.toDouble(),
              width: barWidth,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              borderSide: const BorderSide(
                width: 1,
              ),
              colors: [
                Theme.of(context).primaryColor,
              ]
            ),
          ],
        ),
      );
    });

    return Scaffold( //차트의 디자인을 조정한다.
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    value: selectedYear,
                    dropdownColor: Colors.white,
                    items: List.generate(5, (index) {
                      return DropdownMenuItem<int>(
                        value: DateTime.now().year - index,
                        child: Text(
                          "${(DateTime.now().year - index).toString()}년",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20
                          ),
                        ),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!;
                      });
                    },
                    underline: Container(),
                    icon: Container(),
                  ),
                  Icon(Icons.expand_more, color: Colors.black54,)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 25),
                  Text(
                    '  ${selectedYear}년 독서 현황  ',
                    style: TextStyle(fontSize: 25),
                  ),
                  const Icon(Icons.menu_book, size: 25),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Builder(
                  builder: (BuildContext context) {
                    if (barGroups.isEmpty) {
                      return const Center(
                        child: Text('아직 저장된 책이 없습니다.'),
                      );
                    } else {
                      return BarChart(
                        BarChartData(
                          barGroups: barGroups,
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTitles: (value) {
                                int combinedValue = value.toInt();
                                int month = (combinedValue - 1) % 12 + 1;
                                return '${month.toString().padLeft(2, '0')}';
                              },
                            ),
                            topTitles: SideTitles(showTitles: false),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTitles: (value) {
                                int intValue = value.toInt();
                                if (lastIntValue != intValue) {
                                  lastIntValue = intValue;
                                  return intValue.toString();
                                } else {
                                  return '';
                                }
                              },
                            ),
                            rightTitles: SideTitles(showTitles: false),
                          ),
                          minY: 0,
                          maxY: readBooksPerMonth.isNotEmpty
                              ? readBooksPerMonth.values.reduce((a, b) => a > b ? a : b) + 1
                              : 0,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Row( //선택한 년도에 읽은 책의 총 권수를 알려준다.
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                  text: '${selectedYear}년도에 총 '
                    ),
                    TextSpan(
                        text: '${readBooksPerMonth.isNotEmpty ? readBooksPerMonth.values.reduce((a, b) => a + b) : 0}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
                    ),
                    TextSpan(
                      text: '권 읽으셨어요! 👍'
                    )
                  ]
              ),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
