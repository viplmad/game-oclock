import 'dart:collection';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import 'series_element.dart';

class StatisticsPieChart<N extends num> extends StatelessWidget {
  const StatisticsPieChart({
    super.key,
    required this.id,
    required this.values,
    required this.colourGetter,
    this.valueFormatter,
    this.onTap,
  });

  final String id;
  final List<SeriesEntry<N>> values;
  final Color Function(String domain, int index) colourGetter;
  final String Function(String domain, N value)? valueFormatter;
  final ValueChanged<int>? onTap;

  @override
  Widget build(final context) {
    final String Function(String, N) labelAccessor =
        valueFormatter ?? (_, final value) => value.toString();

    final data = values.indexed
        .map((final indexed) {
          final entry = indexed.$2;
          final currentLabel = entry.key;
          final currentValue = entry.value;

          return SeriesElement<N>(indexed.$1, currentLabel, currentValue);
        })
        .toList(growable: false);

    final outsideTextColour = charts.ColorUtil.fromDartColor(
      defaultThemeTextColor(context),
    );

    final series = charts.Series<SeriesElement<N>, String>(
      id: id,
      colorFn: (final element, _) => charts.ColorUtil.fromDartColor(
        colourGetter(element.domainLabel, element.index),
      ),
      domainFn: (final element, _) => element.domainLabel,
      measureFn: (final element, _) => element.value,
      data: data,
      labelAccessorFn: (final element, _) => element.value > 0
          ? labelAccessor(element.domainLabel, element.value)
          : '',
      outsideLabelStyleAccessorFn: (_, _) =>
          charts.TextStyleSpec(color: outsideTextColour),
    );

    final seriesList = [series];

    return charts.PieChart<String>(
      seriesList,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig<String>(
        arcWidth: 100,
        // ignore: always_specify_types
        arcRendererDecorators: [charts.ArcLabelDecorator<String>()],
      ),
      selectionModels: onTap != null
          ? <charts.SelectionModelConfig<String>>[
              charts.SelectionModelConfig<String>(
                updatedListener: (final model) {
                  final firstDatum = model.selectedDatum.firstOrNull;
                  if (firstDatum != null && firstDatum.index != null) {
                    final domainIndex = firstDatum.index!;
                    onTap!(domainIndex);
                  }
                },
              ),
            ]
          : null,
    );
  }
}
