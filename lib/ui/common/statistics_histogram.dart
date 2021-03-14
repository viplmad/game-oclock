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
    List<_SeriesElement<N>> data = [];

    for(int index = 0; index < domainLabels.length; index++) {
      String currentLabel =  domainLabels.elementAt(index);
      N currentValue = values.elementAt(index);

      _SeriesElement<N> seriesElement = _SeriesElement<N>(currentLabel, currentValue);
      data.add(seriesElement);
    }

    final Series<_SeriesElement<N>, String> series = Series<_SeriesElement<N>, String>(
      id: histogramName,
      colorFn: (_, __) => ColorUtil.fromDartColor(Theme.of(context).primaryColor),
      domainFn: (_SeriesElement<N> element, _) => element.domainLabel,
      measureFn: (_SeriesElement<N> element, _) => element.value,
      data: data,

      labelAccessorFn: labelAccessor != null? (_SeriesElement<N> element, _) => labelAccessor!(element.domainLabel, element.value) : null,
    );

    final List<Series<_SeriesElement<N>, String>> seriesList = [
      series
    ];

    return BarChart(
      seriesList,
      animate: true,
      vertical: vertical,
      barRendererDecorator: BarLabelDecorator<String>(),
      domainAxis: hideDomainLabels? OrdinalAxisSpec(renderSpec: NoneRenderSpec()) : OrdinalAxisSpec(),
    );
  }
}
class _SeriesElement<N extends num> {
  const _SeriesElement(this.domainLabel, this.value);

  final String domainLabel;
  final N value;
}