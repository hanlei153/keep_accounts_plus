import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final List<PieChartSectionData> sections;
  PieChartWidget({required this.sections});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: sections,
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 40, // 饼图中心的半径
      ),
    );
  }

  // 计算每个分类的百分比
  static double calculatePercentage(
      double amount, Map<String, double> sections) {
    double total = 0;
    sections.forEach((category, value) {
      total += value;
    });
    print(total);

    if (amount == 0) {
      return 0;
    }
    return (amount / total) * 100;
  }

  // 封装一个方法来生成饼图数据
  static List<PieChartSectionData> generateSections(Map<String, double> data) {
    List<PieChartSectionData> sections = [];

    data.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: _getColorForCategory(category),
          value: amount,
          title: '${calculatePercentage(amount, data).toStringAsFixed(2)}%',
          radius: 60, // 设置饼图扇区的半径
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          titlePositionPercentageOffset: 1.3, // 标题偏移到外部
        ),
      );
    });
    return sections;
  }

  // 根据不同的分类给饼图每个扇区设置颜色
  static Color _getColorForCategory(String category) {
    switch (category) {
      case '餐饮':
        return Colors.blue;
      case '水果':
        return Colors.green;
      case '购物':
        return Colors.orange;
      case '交通':
        return Colors.red;
      case '娱乐':
        return const Color.fromRGBO(51, 145, 233, 0.8);
      case '住房':
        return const Color.fromRGBO(117, 223, 56, 0.8);
      case '社交':
        return const Color.fromRGBO(236, 204, 62, 0.8);
      case '旅行':
        return const Color.fromRGBO(87, 188, 255, 0.8);
      case '宠物':
        return const Color.fromRGBO(255, 99, 99, 0.8);
      case '医疗':
        return const Color.fromRGBO(116, 255, 174, 0.8);
      case '服饰':
        return const Color.fromRGBO(102, 255, 255, 0.8);
      case '工资':
        return const Color.fromRGBO(135, 181, 250, 0.8);
      case '兼职':
        return const Color.fromRGBO(127, 255, 191, 0.8);
      case '理财':
        return const Color.fromRGBO(156, 247, 231, 0.8);
      case '礼金':
        return const Color.fromRGBO(209, 110, 226, 0.8);
      default:
        return Colors.grey;
    }
  }
}

// class AnalyzePage extends StatefulWidget {
//   AnalyzePage({super.key});
//   @override
//   State<AnalyzePage> createState() => _AnalyzePageState();
// }

// class _AnalyzePageState extends State<AnalyzePage> {
//   int touchedIndex = -1;
//   Color text1 = Colors.black;
//   @override
//   Widget build(BuildContext context) {
//     List<PieChartSectionData> showingSections() {
//       return List.generate(4, (i) {
//         final isTouched = i == touchedIndex;
//         final fontSize = isTouched ? 25.0 : 16.0;
//         final radius = isTouched ? 60.0 : 50.0;
//         const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
//         switch (i) {
//           case 0:
//             return PieChartSectionData(
//               color: const Color.fromRGBO( 90, 175, 245),
//               value: 40,
//               title: '40%',
//               radius: radius,
//               titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 shadows: shadows,
//               ),
//             );
//           case 1:
//             return PieChartSectionData(
//               color: const Color.fromRGBO( 247, 177, 86),
//               value: 30,
//               title: '30%',
//               radius: radius,
//               titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 shadows: shadows,
//               ),
//             );
//           case 2:
//             return PieChartSectionData(
//               color: const Color.fromRGBO( 175, 101, 245),
//               value: 15,
//               title: '15%',
//               radius: radius,
//               titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 shadows: shadows,
//               ),
//             );
//           case 3:
//             return PieChartSectionData(
//               color: const Color.fromRGBO( 89, 247, 220),
//               value: 15,
//               title: '15%',
//               radius: radius,
//               titleStyle: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//                 shadows: shadows,
//               ),
//             );
//           default:
//             throw Error();
//         }
//       });
//     }

//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           title: const Center(child: Text('账单分析')),
//         ),
//         body: AspectRatio(
//           aspectRatio: 1.3,
//           child: Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     '1',
//                     style: TextStyle(color: text1),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     '2',
//                     style: TextStyle(color: text1),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     '3',
//                     style: TextStyle(color: text1),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     '4',
//                     style: TextStyle(color: text1),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: AspectRatio(
//                   aspectRatio: 1,
//                   child: PieChart(
//                     PieChartData(
//                       sections: showingSections(),
//                       borderData: FlBorderData(
//                         show: false,
//                       ),
//                       sectionsSpace: 0,
//                       centerSpaceRadius: 40,
//                       pieTouchData: PieTouchData(
//                         touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                           setState(() {
//                             if (!event.isInterestedForInteractions ||
//                                 pieTouchResponse == null ||
//                                 pieTouchResponse.touchedSection == null) {
//                               touchedIndex = -1;
//                               return;
//                             }

//                             if (pieTouchResponse
//                                     .touchedSection!.touchedSection?.color !=
//                                 null) {
//                               text1 = pieTouchResponse
//                                   .touchedSection!.touchedSection!.color;
//                             }

//                             touchedIndex = pieTouchResponse
//                                 .touchedSection!.touchedSectionIndex;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
