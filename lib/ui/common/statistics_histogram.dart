import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';


class StatisticsHistogram<N extends num> extends StatelessWidget {
  const StatisticsHistogram({
    Key? key,
    required this.histogramName,
    required this.domainLabels,
    required this.values,
    this.vertical = true,
    this.hideDomainLabels = false,
    this.labelAccessor,
  }) : super(key: key);

  final String histogramName;
  final List<String> domainLabels;
  final List<N> values;
  final bool vertical;
  final bool hideDomainLabels;
  final String Function(String, N)? labelAccessor;

  @override
  Widget build(BuildContext context) {
    final List<_SeriesElement<N>> data = <_SeriesElement<N>>[];

    for(int index = 0; index < domainLabels.length; index++) {
      final String currentLabel =  domainLabels.elementAt(index);
      final N currentValue = values.elementAt(index);

      final _SeriesElement<N> seriesElement = _SeriesElement<N>(currentLabel, currentValue);
      data.add(seriesElement);
    }

    final BarChartData barData = BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
            return BarTooltipItem(
              data.elementAt(groupIndex).domainLabel + '\n',
              const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.y).toString(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),
        touchCallback: (BarTouchResponse barTouchResponse) {},
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (double value) {
            return data.where((_SeriesElement<N> element) => (element.value as int).toDouble() == value).first.domainLabel;
          },
          getTextStyles: (double value) {
            return const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14);
          },
          margin: 16,
        ),
        leftTitles: SideTitles(
          showTitles: true, //TODO
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: data.map((_SeriesElement<N> e) {
        return BarChartGroupData(
          x: e.value as int,
          barRods: <BarChartRodData>[
            BarChartRodData(
              y: (e.value as int).toDouble(),
            ),
          ],
        );
      }).toList(growable: false),
    );

    return BarChart(
      barData,
    );
  }
}
class _SeriesElement<N extends num> {
  const _SeriesElement(this.domainLabel, this.value);

  final String domainLabel;
  final N value;
}