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
    return StatisticsStackedBarChart<N>(
      id: id,
      values: values
          .map(
            (final el) => SeriesEntry(
              key: el.key,
              value: List<SeriesEntry<N>>.unmodifiable(<SeriesEntry<N>>[
                SeriesEntry(key: 'val', value: el.value),
              ]),
            ),
          )
          .toList(growable: false),
      colourGetter: (final domain, _, final index, _) =>
          colourGetter(domain, index),
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
    required this.values,
    required this.colourGetter,
    this.vertical = true,
    this.hideDomainLabels = false,
    this.hideValueLabels = false,
    this.valueFormatter,
    this.measureFormatter,
    this.onTap,
  });

  final String id;
  final List<SeriesEntry<List<SeriesEntry<N>>>> values;
  final Color Function(
    String domain,
    String label,
    int domainIndex,
    int labelIndex,
  )
  colourGetter;
  final bool vertical;
  final bool hideDomainLabels;
  final bool hideValueLabels;
  final String Function(N value)? valueFormatter;
  final String Function(num? measure)? measureFormatter;
  final ValueChanged<int>? onTap;

  @override
  Widget build(final context) {
    final String Function(N) labelAccessor = hideValueLabels
        ? (_) => ''
        : valueFormatter ?? (final value) => value.toString();

    final charts.Color outsideTextColour = charts.ColorUtil.fromDartColor(
      defaultThemeTextColor(context),
    );

    final temp = <SeriesEntry<List<SeriesEntry<N>>>>[];
    final uniqueSubLabels = values
        .map((final e) => e.value.map((final e) => e.key))
        .fold(<String>{}, (final prev, final el) => prev..addAll(el))
        .toList(growable: false);
    // Normalise
    uniqueSubLabels.forEach((final subLabel) {
      temp.add(SeriesEntry(key: subLabel, value: []));
    });

    values.indexed.forEach((final indexed) {
      final entry = indexed.$2;
      final currentLabel = entry.key;
      final currentValue = entry.value;

      // Normalise
      uniqueSubLabels.forEach((final subLabel) {
        temp
            .firstWhere((final el) => el.key == subLabel)
            .value
            .add(SeriesEntry(key: currentLabel, value: 0 as N));
      });

      currentValue.indexed.forEach((final subIndexed) {
        final subEntry = subIndexed.$2;
        final currentSubLabel = subEntry.key;
        final currentSubValue = subEntry.value;

        temp.firstWhere((final el) => el.key == currentSubLabel).value.setAll(
          indexed.$1,
          [SeriesEntry(key: currentLabel, value: currentSubValue)],
        );
      });
    });

    final seriesList = temp.indexed
        .map((final indexed) {
          final entry = indexed.$2;
          final currentLabel = entry.key; // id
          final currentValue = entry.value;

          final data = currentValue.indexed
              .map((final subIndexed) {
                final subEntry = subIndexed.$2;
                final currentSubLabel = subEntry.key;
                final currentSubValue = subEntry.value;

                return SeriesElement<N>(
                  subIndexed.$1,
                  currentSubLabel, // year
                  currentSubValue,
                );
              })
              .toList(growable: false);

          return charts.Series<SeriesElement<N>, String>(
            id: currentLabel,
            colorFn: (final element, _) => charts.ColorUtil.fromDartColor(
              colourGetter(
                element.domainLabel,
                currentLabel,
                element.index,
                uniqueSubLabels.indexOf(currentLabel),
              ),
            ),
            domainFn: (final element, _) => element.domainLabel,
            measureFn: (final element, _) => element.value,
            data: data,
            labelAccessorFn: (final element, _) =>
                element.value > 0 ? labelAccessor(element.value) : '',
            outsideLabelStyleAccessorFn: (_, _) =>
                charts.TextStyleSpec(color: outsideTextColour),
          );
        })
        .toList(growable: false);

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
