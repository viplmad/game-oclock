import 'dart:collection';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';
import 'package:game_oclock/components/charts/series_element.dart';

class StatisticsBarChart<N extends num> extends StatelessWidget {
  const StatisticsBarChart({
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
  final SplayTreeMap<String, N> values;
  final Color? colour;
  final bool vertical;
  final bool hideDomainLabels;
  final bool hideValueLabels;
  final String Function(N)? valueFormatter;
  final String Function(num?)? measureFormatter;
  final ValueChanged<int>? onDomainTap;

  @override
  Widget build(final context) {
    return StatisticsStackedBarChart<N>(
      id: id,
      domainLabels: values.keys.toList(growable: false),
      stackedValues: [values.values.toList(growable: false)],
      colours: colour != null ? <Color>[colour!] : <Color>[],
      vertical: vertical,
      hideDomainLabels: hideDomainLabels,
      hideValueLabels: hideValueLabels,
      valueFormatter: valueFormatter,
      measureFormatter: measureFormatter,
      onTap: onDomainTap,
    );
  }
}

class StatisticsStackedBarChart<N extends num> extends StatelessWidget {
  const StatisticsStackedBarChart({
    super.key,
    required this.id,
    required this.domainLabels,
    required this.stackedValues,
    this.colours = const <Color>[],
    this.vertical = true,
    this.hideDomainLabels = false,
    this.hideValueLabels = false,
    this.valueFormatter,
    this.measureFormatter,
    this.onTap,
  });

  final String id;
  final List<String> domainLabels;
  final List<List<N>> stackedValues;
  final List<Color> colours;
  final bool vertical;
  final bool hideDomainLabels;
  final bool hideValueLabels;
  final String Function(N)? valueFormatter;
  final String Function(num?)? measureFormatter;
  final ValueChanged<int>? onTap;

  @override
  Widget build(final context) {
    final String Function(N) labelAccessor = hideValueLabels
        ? (_) => ''
        : valueFormatter ?? (final value) => value.toString();

    final seriesList = <charts.Series<SeriesElement<N>, String>>[];

    for (int valueIndex = 0; valueIndex < stackedValues.length; valueIndex++) {
      final List<N> values = stackedValues.elementAt(valueIndex);
      final Color colour = colours.isEmpty
          ? Theme.of(context).primaryColor
          : colours.elementAt(valueIndex);
      final charts.Color seriesColour = charts.ColorUtil.fromDartColor(colour);
      final charts.Color outsideTextColour = charts.ColorUtil.fromDartColor(
        defaultThemeTextColor(context),
      );

      final data = SplayTreeMap.fromIterables(domainLabels, values)
          .entries
          .indexed
          .map((final indexed) {
            final entry = indexed.$2;
            final currentLabel = entry.key;
            final currentValue = entry.value;

            return SeriesElement<N>(indexed.$1, currentLabel, currentValue);
          })
          .toList(growable: false);

      final series = charts.Series<SeriesElement<N>, String>(
        id: valueIndex.toString(),
        colorFn: (_, __) => seriesColour,
        domainFn: (final element, _) => element.domainLabel,
        measureFn: (final element, _) => element.value,
        data: data,
        labelAccessorFn: (final element, _) =>
            element.value > 0 ? labelAccessor(element.value) : '',
        outsideLabelStyleAccessorFn: (_, __) =>
            charts.TextStyleSpec(color: outsideTextColour),
      );

      seriesList.add(series);
    }

    final textStyleSpec = charts.TextStyleSpec(
      color: charts.ColorUtil.fromDartColor(defaultThemeTextColor(context)),
    );

    return charts.BarChart(
      seriesList,
      animate: true,
      barGroupingType: seriesList.length > 1
          ? charts.BarGroupingType.stacked
          : null,
      vertical: vertical,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: hideDomainLabels
          ? const charts.OrdinalAxisSpec(
              renderSpec: charts.NoneRenderSpec<String>(),
            )
          : charts.OrdinalAxisSpec(
              renderSpec: charts.GridlineRendererSpec<String>(
                labelStyle: textStyleSpec,
              ),
            ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec<num>(labelStyle: textStyleSpec),
        tickFormatterSpec: measureFormatter != null
            ? charts.BasicNumericTickFormatterSpec(measureFormatter)
            : null,
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
