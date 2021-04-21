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
    this.valueFormatter,
  }) : super(key: key);

  final String histogramName;
  final List<String> domainLabels;
  final List<N> values;
  final bool vertical;
  final bool hideDomainLabels;
  final String Function(N)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final String Function(N) labelAccessor = valueFormatter?? (N value) => value.toString();

    final List<_SeriesElement<N>> data = <_SeriesElement<N>>[];
    N max = values.first;
    for(int index = 0; index < domainLabels.length; index++) {
      final String currentLabel = domainLabels.elementAt(index);
      final N currentValue = values.elementAt(index);

      final _SeriesElement<N> seriesElement = _SeriesElement<N>(index, currentLabel, currentValue);
      data.add(seriesElement);

      if(currentValue > max) {
        max = currentValue;
      }
    }

    final BarChartData barData = BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
            final _SeriesElement<N> element = data.elementAt(groupIndex);

            return BarTooltipItem(
              element.domainLabel + '\n',
              const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: labelAccessor(element.value),
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
            final _SeriesElement<N> element = data.elementAt(value.toInt());
            return element.domainLabel;
          },
          getTextStyles: (double value) {
            return const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14);
          },
          margin: 16,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: max / 3,
          getTitles: (double value) {
            return labelAccessor(value.toInt() as N);
          },
          reservedSize: 48,
          margin: 16,
        ),
        rightTitles: SideTitles(
          showTitles: false,
          margin: 16,
        ),
        topTitles: SideTitles(
          showTitles: false,
          margin: 16,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: data.map((_SeriesElement<N> element) {
        return BarChartGroupData(
          x: element.index,
          barRods: <BarChartRodData>[
            BarChartRodData(
              y: element.value.toDouble(),
              width: 30,
            ),
          ],
        );
      }).toList(growable: false),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 16.0),
      child: BarChart(
        barData,
      ),
    );
  }
}
class _SeriesElement<N extends num> {
  const _SeriesElement(this.index, this.domainLabel, this.value);

  final int index;
  final String domainLabel;
  final N value;
}