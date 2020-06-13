import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/components/homepage_card.dart';
import 'package:snapsheetapp/models/category.dart';
import 'package:snapsheetapp/models/record.dart';
import 'package:snapsheetapp/models/stats.dart';
import 'package:snapsheetapp/models/user_data.dart';
import 'package:random_color/random_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'history_tile.dart';
import 'indicator.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final RandomColor _randomColor = RandomColor();
  int touchedIndex;
  void updateTouchedIndex(int i) {
    print("input is: $i");
    if (i != null) {
      touchedIndex = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, userData, child) {
        List<Category> cats = userData.categories;
        List<PieChartSectionData> showingCategorySections() {
          return List.generate(
            cats.length,
            (i) {
              final Category cat = cats[i];
              final bool isTouched = i == touchedIndex;
              final double opacity = isTouched ? 1 : 0.6;
              final value = userData.getCategTotalFromCurrent(i);
              switch (i) {
                default:
                  return PieChartSectionData(
                    color: cat.color.withOpacity(opacity),
                    value: value,
                    showTitle: isTouched && value > 0,
                    title: '${value.toString()}',
                    radius: isTouched ? 50 : 40,
                    titleStyle: TextStyle(
                        fontSize: 18, color: Colors.black.withOpacity(0.8)),
                    titlePositionPercentageOffset: 0.5,
                  );
              }
            },
          );
        }

        return Column(
          children: <Widget>[
//            HomepageCard(
//              cardChild: Container(
//                height: 250,
//                child: Padding(
//                  padding: const EdgeInsets.all(20.0),
//                  child: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Flexible(
//                        child: Text('Total: ${userData.statsTotal}'),
//                        fit: FlexFit.loose,
//                      ),
//                      Flexible(
//                        fit: FlexFit.loose,
//                        child: Text(
//                          'Account: ${userData.selectedAccount == -1 ? "all" : userData.accounts[userData.selectedAccount].title} \n\n'
//                          'Height Test for scrollable.',
//                          textAlign: TextAlign.center,
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
            Card(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Expenses Breakdown',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Total: \$${userData.statsTotal}',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(
                                  touchCallback: (pieTouchResponse) {
                                setState(() {
                                  updateTouchedIndex(
                                      pieTouchResponse.touchedSectionIndex);
                                  userData.changeTempRecord(touchedIndex);
                                  print(touchedIndex);
                                });
                              }),
                              startDegreeOffset: 180,
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: showingCategorySections()),
                        ),
                      ),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 3,
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        children: cats
                            .where((e) =>
                                userData
                                    .getCategTotalFromCurrent(cats.indexOf(e)) >
                                0)
                            .toList()
                            .map(
                          (e) {
                            double value = userData
                                .getCategTotalFromCurrent(cats.indexOf(e));
                            return Indicator(
                              color: e.color,
                              text: e.title,
                              isSquare: false,
                              size: touchedIndex == cats.indexOf(e) && value > 0
                                  ? 10
                                  : 8,
                              textColor:
                                  touchedIndex == cats.indexOf(e) && value > 0
                                      ? Colors.black
                                      : Colors.grey,
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            HomepageCard(
              cardChild: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Records History',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 4.0, right: 8.0, bottom: 15.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // print(userData.recordsCount);
                          final record = userData.records[index];
                          return Visibility(
                            visible:
                                record.accountId == userData.selectedAccount ||
                                    userData.selectedAccount == -1,
                            child: HistoryTile(record: record, index: index),
                          );
                        },
                        itemCount: userData.recordsCount,
                      ),
                    ),
                  ),
                ],
              ),
            ),
//            HomepageCard(
//              cardChild: Container(
//                height: 250,
//              ),
//            ),
          ],
        );
      },
    );
  }
}
