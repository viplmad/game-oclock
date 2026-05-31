import 'dart:collection';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'series_element.dart';

class StatisticsLineChart<N extends num> extends StatelessWidget {
  const StatisticsLineChart({
    super.key,
    required this.id,
    required this.values,
    required this.colourGetter,
    this.vertical = true,
    this.hideDomainLabels = false,
    this.hideValueLabels = false,
    this.valueFormatter,
    this.measureFormatter,
    this.onDomainTap,
  });

  final String id;
  final List<SeriesEntry<N>> values;
  final Color Function(String domain, int index) colourGetter;
  final bool vertical;
  final bool hideDomainLabels;
  final bool hideValueLabels;
  final String Function(N value)? valueFormatter;
  final String Function(num? measure)? measureFormatter;
  final ValueChanged<int>? onDomainTap;

  @override
  Widget build(final context) {
    final String Function(N) labelAccessor = hideValueLabels
        ? (_) => ''
        : valueFormatter ?? (final value) => value.toString();

    final outsideTextColour = charts.ColorUtil.fromDartColor(
      defaultThemeTextColor(context),
    );

    final data = values.indexed
        .map((final indexed) {
          final entry = indexed.$2;
          final currentLabel = entry.key;
          final currentValue = entry.value;

          return SeriesElement<N>(indexed.$1, currentLabel, currentValue);
        })
        .toList(growable: false);

    final series = charts.Series<SeriesElement<N>, int>(
      id: id,
      colorFn: (final element, _) => charts.ColorUtil.fromDartColor(
        colourGetter(element.domainLabel, element.index),
      ),
      domainFn: (final element, _) => element.index,
      measureFn: (final element, _) => element.value,
      data: data,
      labelAccessorFn: (final element, _) =>
          element.value > 0 ? labelAccessor(element.value) : '',
      outsideLabelStyleAccessorFn: (_, _) =>
          charts.TextStyleSpec(color: outsideTextColour),
    );

    final seriesList = [series];

    final textStyleSpec = charts.TextStyleSpec(
      color: charts.ColorUtil.fromDartColor(defaultThemeTextColor(context)),
    );

    return charts.LineChart(
      seriesList,
      animate: true,
      defaultRenderer: charts.LineRendererConfig<num>(includePoints: true),
      domainAxis: hideDomainLabels
          ? const charts.NumericAxisSpec(
              renderSpec: charts.NoneRenderSpec<num>(),
            )
          : charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec<num>(
                labelStyle: textStyleSpec,
              ),
              tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                // WTF ??
                (final measure) => (measure?.toInt() ?? 0) < values.length
                    ? values.elementAt(measure?.toInt() ?? 0).key
                    : '',
              ),
            ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec<num>(labelStyle: textStyleSpec),
        tickFormatterSpec: measureFormatter != null
            ? charts.BasicNumericTickFormatterSpec(measureFormatter)
            : null,
      ),
    );
  }
}
