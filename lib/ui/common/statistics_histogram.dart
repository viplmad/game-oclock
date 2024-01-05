import 'package:flutter/material.dart';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

class StatisticsHistogram<N extends num> extends StatelessWidget {
  const StatisticsHistogram({
    Key? key,
    required this.name,
    required this.domainLabels,
    required this.values,
    this.vertical = true,
    this.hideDomainLabels = false,
    this.valueFormatter,
  }) : super(key: key);

  final String name;
  final List<String> domainLabels;
  final List<N> values;
  final bool vertical;
  final bool hideDomainLabels;
  final String Function(N)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    return StatisticsStackedHistogram<N>(
      name: name,
      domainLabels: domainLabels,
      stackedValues: <List<N>>[values],
      vertical: vertical,
      hideDomainLabels: hideDomainLabels,
      valueFormatter: valueFormatter,
    );
  }
}

class StatisticsStackedHistogram<N extends num> extends StatelessWidget {
  const StatisticsStackedHistogram({
    Key? key,
    required this.name,
    required this.domainLabels,
    required this.stackedValues,
    this.colours = const <Color>[],
    this.vertical = true,
    this.hideDomainLabels = false,
    this.valueFormatter,
  }) : super(key: key);

  final String name;
  final List<String> domainLabels;
  final List<List<N>> stackedValues;
  final List<Color> colours;
  final bool vertical;
  final bool hideDomainLabels;
  final String Function(N)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final String Function(N) labelAccessor =
        valueFormatter ?? (N value) => value.toString();

    final List<charts.Series<_SeriesElement<N>, String>> seriesList =
        <charts.Series<_SeriesElement<N>, String>>[];

    for (int valueIndex = 0; valueIndex < stackedValues.length; valueIndex++) {
      final List<N> values = stackedValues.elementAt(valueIndex);
      final Color colour = colours.isEmpty
          ? Theme.of(context).primaryColor
          : colours.elementAt(valueIndex);

      final List<_SeriesElement<N>> data = <_SeriesElement<N>>[];

      for (int index = 0; index < domainLabels.length; index++) {
        final String currentLabel = domainLabels.elementAt(index);
        final N currentValue = values.elementAt(index);

        final _SeriesElement<N> seriesElement =
            _SeriesElement<N>(index, currentLabel, currentValue);
        data.add(seriesElement);
      }

      final charts.Series<_SeriesElement<N>, String> series =
          charts.Series<_SeriesElement<N>, String>(
        id: valueIndex.toString(),
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(colour),
        domainFn: (_SeriesElement<N> element, _) => element.domainLabel,
        measureFn: (_SeriesElement<N> element, _) => element.value,
        data: data,

        //domainFormatterFn: (_, index) => domainAccessor(index),
        labelAccessorFn: (_SeriesElement<N> element, _) =>
            element.value > 0 ? labelAccessor(element.value) : '',
      );

      seriesList.add(series);
    }

    return charts.BarChart(
      seriesList,
      animate: true,
      barGroupingType:
          seriesList.length > 1 ? charts.BarGroupingType.stacked : null,
      vertical: vertical,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: hideDomainLabels
          ? const charts.OrdinalAxisSpec(
              renderSpec: charts.NoneRenderSpec<String>(),
            )
          : const charts.OrdinalAxisSpec(),
    );
  }
}

class StatisticsPieChart<N extends num> extends StatelessWidget {
  const StatisticsPieChart({
    Key? key,
    required this.name,
    required this.domainLabels,
    required this.values,
    this.colours = const <Color>[],
    this.valueFormatter,
  }) : super(key: key);

  final String name;
  final List<String> domainLabels;
  final List<N> values;
  final List<Color> colours;
  final String Function(String, N)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final String Function(String, N) labelAccessor =
        valueFormatter ?? (String domainLabel, N value) => value.toString();

    final List<_SeriesElement<N>> data = <_SeriesElement<N>>[];

    for (int index = 0; index < domainLabels.length; index++) {
      final String currentLabel = domainLabels.elementAt(index);
      final N currentValue = values.elementAt(index);

      final _SeriesElement<N> seriesElement =
          _SeriesElement<N>(index, currentLabel, currentValue);
      data.add(seriesElement);
    }

    final charts.Series<_SeriesElement<N>, String> series =
        charts.Series<_SeriesElement<N>, String>(
      id: name,
      colorFn: (_SeriesElement<N> element, __) =>
          charts.ColorUtil.fromDartColor(
        colours.isEmpty
            ? Theme.of(context).primaryColor
            : colours.elementAt(element.index),
      ),
      domainFn: (_SeriesElement<N> element, _) => element.domainLabel,
      measureFn: (_SeriesElement<N> element, _) => element.value,
      data: data,

      //domainFormatterFn: (_, index) => domainAccessor(index),
      labelAccessorFn: (_SeriesElement<N> element, _) => element.value > 0
          ? labelAccessor(element.domainLabel, element.value)
          : '',
    );

    final List<charts.Series<_SeriesElement<N>, String>> seriesList =
        <charts.Series<_SeriesElement<N>, String>>[series];

    return charts.PieChart<String>(
      seriesList,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig<String>(
        arcWidth: 90,
        // ignore: always_specify_types
        arcRendererDecorators: [
          charts.ArcLabelDecorator<String>(),
        ],
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
