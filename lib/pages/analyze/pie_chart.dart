import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyzePage extends StatefulWidget {
  AnalyzePage({super.key});
  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  int touchedIndex = -1;
  Color text1 = Colors.black;
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> showingSections() {
      return List.generate(4, (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color.fromARGB(255, 90, 175, 245),
              value: 40,
              title: '40%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                shadows: shadows,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: const Color.fromARGB(255, 247, 177, 86),
              value: 30,
              title: '30%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                shadows: shadows,
              ),
            );
          case 2:
            return PieChartSectionData(
              color: const Color.fromARGB(255, 175, 101, 245),
              value: 15,
              title: '15%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                shadows: shadows,
              ),
            );
          case 3:
            return PieChartSectionData(
              color: const Color.fromARGB(255, 89, 247, 220),
              value: 15,
              title: '15%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                shadows: shadows,
              ),
            );
          default:
            throw Error();
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Center(child: Text('账单分析')),
        ),
        body: AspectRatio(
          aspectRatio: 1.3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '1',
                    style: TextStyle(color: text1),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '2',
                    style: TextStyle(color: text1),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '3',
                    style: TextStyle(color: text1),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '4',
                    style: TextStyle(color: text1),
                  ),
                ],
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: showingSections(),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }

                            if (pieTouchResponse
                                    .touchedSection!.touchedSection?.color !=
                                null) {
                              text1 = pieTouchResponse
                                  .touchedSection!.touchedSection!.color;
                            }

                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
