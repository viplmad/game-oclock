import 'dart:collection';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'series_element.dart';

class StatisticsLineChart extends StatelessWidget {
  const StatisticsLineChart({
    super.key,
    required this.id,
    required this.values,
    this.colour,
    this.vertical = true,
    this.hideDomainLabels = false,
    this.hideValueLabels = false,
    this.valueFormatter,
    this.measureFormatter,
    this.onDomainTap,
  });

  final String id;
  final SplayTreeMap<String, int> values;
  final Color? colour;
  final bool vertical;
  final bool hideDomainLabels;
  final bool hideValueLabels;
  final String Function(int)? valueFormatter;
  final String Function(num?)? measureFormatter;
  final ValueChanged<int>? onDomainTap;

  @override
  Widget build(final context) {
    final String Function(int) labelAccessor = hideValueLabels
        ? (_) => ''
        : valueFormatter ?? (final int value) => value.toString();

    final finalColour = colour ?? Theme.of(context).primaryColor;
    final seriesColour = charts.ColorUtil.fromDartColor(finalColour);
    final outsideTextColour = charts.ColorUtil.fromDartColor(
      defaultThemeTextColor(context),
    );

    final data = values.entries.indexed
        .map((final indexed) {
          final entry = indexed.$2;
          final currentLabel = entry.key;
          final currentValue = entry.value;

          return SeriesElement<int>(indexed.$1, currentLabel, currentValue);
        })
        .toList(growable: false);

    final series = charts.Series<SeriesElement<int>, int>(
      id: id,
      colorFn: (_, __) => seriesColour,
      domainFn: (final element, _) => element.index,
      measureFn: (final element, _) => element.value,
      data: data,
      labelAccessorFn: (final element, _) =>
          element.value > 0 ? labelAccessor(element.value) : '',
      outsideLabelStyleAccessorFn: (_, __) =>
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
                    ? values.keys.elementAt(measure?.toInt() ?? 0)
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
