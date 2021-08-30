import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart';


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

    for(int index = 0; index < domainLabels.length; index++) {
      final String currentLabel = domainLabels.elementAt(index);
      final N currentValue = values.elementAt(index);

      final _SeriesElement<N> seriesElement = _SeriesElement<N>(index, currentLabel, currentValue);
      data.add(seriesElement);
    }

    final Series<_SeriesElement<N>, String> series = Series<_SeriesElement<N>, String>(
      id: histogramName,
      colorFn: (_, __) => ColorUtil.fromDartColor(Theme.of(context).primaryColor),
      domainFn: (_SeriesElement<N> element, _) => element.domainLabel,
      measureFn: (_SeriesElement<N> element, _) => element.value,
      data: data,

      //domainFormatterFn: (_, index) => domainAccessor(index),
      labelAccessorFn: (_SeriesElement<N> element, _) => labelAccessor(element.value),
    );

    final List<Series<_SeriesElement<N>, String>> seriesList = <Series<_SeriesElement<N>, String>>[
      series
    ];

    return BarChart(
      seriesList,
      animate: true,
      vertical: vertical,
      barRendererDecorator: BarLabelDecorator<String>(),
      domainAxis: hideDomainLabels? const OrdinalAxisSpec(renderSpec: NoneRenderSpec<String>()) : const OrdinalAxisSpec(),
    );
  }
}
class _SeriesElement<N extends num> {
  const _SeriesElement(this.index, this.domainLabel, this.value);

  final int index;
  final String domainLabel;
  final N value;
}