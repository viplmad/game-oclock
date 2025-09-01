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
    this.colours = const <Color>[],
    this.valueFormatter,
    this.onTap,
  });

  final String id;
  final SplayTreeMap<String, N> values;
  final List<Color> colours;
  final String Function(String, N)? valueFormatter;
  final void Function(int)? onTap;

  @override
  Widget build(final context) {
    final String Function(String, N) labelAccessor =
        valueFormatter ?? (_, final value) => value.toString();

    final data = values.entries.indexed
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
      colorFn: (final element, __) => charts.ColorUtil.fromDartColor(
        colours.isEmpty
            ? Theme.of(context).primaryColor
            : colours.elementAt(element.index),
      ),
      domainFn: (final element, _) => element.domainLabel,
      measureFn: (final element, _) => element.value,
      data: data,
      labelAccessorFn: (final element, _) => element.value > 0
          ? labelAccessor(element.domainLabel, element.value)
          : '',
      outsideLabelStyleAccessorFn: (_, __) =>
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
