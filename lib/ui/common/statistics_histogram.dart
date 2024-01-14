import 'package:flutter/material.dart';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

import 'package:game_oclock/ui/theme/theme.dart' show AppTheme;

class StatisticsHistogram<N extends num> extends StatelessWidget {
  const StatisticsHistogram({
    Key? key,
    required this.id,
    required this.domainLabels,
    required this.values,
    this.colour,
    this.vertical = true,
    this.hideDomainLabels = false,
    this.hideValueLabels = false,
    this.valueFormatter,
    this.measureFormatter,
    this.onDomainTap,
  }) : super(key: key);

  final String id;
  final List<String> domainLabels;
  final List<N> values;
  final Color? colour;
  final bool vertical;
  final bool hideDomainLabels;
  final bool hideValueLabels;
  final String Function(N)? valueFormatter;
  final String Function(num?)? measureFormatter;
  final void Function(int)? onDomainTap;

  @override
  Widget build(BuildContext context) {
    return StatisticsStackedHistogram<N>(
      id: id,
      domainLabels: domainLabels,
      stackedValues: <List<N>>[values],
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

class StatisticsStackedHistogram<N extends num> extends StatelessWidget {
  const StatisticsStackedHistogram({
    Key? key,
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
  }) : super(key: key);

  final String id;
  final List<String> domainLabels;
  final List<List<N>> stackedValues;
  final List<Color> colours;
  final bool vertical;
  final bool hideDomainLabels;
  final bool hideValueLabels;
  final String Function(N)? valueFormatter;
  final String Function(num?)? measureFormatter;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    final String Function(N) labelAccessor = hideValueLabels
        ? (_) => ''
        : valueFormatter ?? (N value) => value.toString();

    final List<charts.Series<_SeriesElement<N>, String>> seriesList =
        <charts.Series<_SeriesElement<N>, String>>[];

    for (int valueIndex = 0; valueIndex < stackedValues.length; valueIndex++) {
      final List<N> values = stackedValues.elementAt(valueIndex);
      final Color colour = colours.isEmpty
          ? Theme.of(context).primaryColor
          : colours.elementAt(valueIndex);
      final charts.Color seriesColour = charts.ColorUtil.fromDartColor(colour);
      final charts.Color outsideTextColour = charts.ColorUtil.fromDartColor(
        AppTheme.defaultThemeTextColor(context),
      );

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
        colorFn: (_, __) => seriesColour,
        domainFn: (_SeriesElement<N> element, _) => element.domainLabel,
        measureFn: (_SeriesElement<N> element, _) => element.value,
        data: data,
        labelAccessorFn: (_SeriesElement<N> element, _) =>
            element.value > 0 ? labelAccessor(element.value) : '',
        outsideLabelStyleAccessorFn: (_, __) =>
            charts.TextStyleSpec(color: outsideTextColour),
      );

      seriesList.add(series);
    }

    final charts.TextStyleSpec textStyleSpec = charts.TextStyleSpec(
      color: charts.ColorUtil.fromDartColor(
        AppTheme.defaultThemeTextColor(context),
      ),
    );

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
          : charts.OrdinalAxisSpec(
              renderSpec: charts.GridlineRendererSpec<String>(
                labelStyle: textStyleSpec,
              ),
            ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec<num>(
          labelStyle: textStyleSpec,
        ),
        tickFormatterSpec: measureFormatter != null
            ? charts.BasicNumericTickFormatterSpec(measureFormatter)
            : null,
      ),
      selectionModels: onTap != null
          ? <charts.SelectionModelConfig<String>>[
              charts.SelectionModelConfig<String>(
                updatedListener: (charts.SelectionModel<String> model) {
                  final charts.SeriesDatum<String>? firstDatum =
                      model.selectedDatum.firstOrNull;
                  if (firstDatum != null && firstDatum.index != null) {
                    final int domainIndex = firstDatum.index!;
                    onTap!(domainIndex);
                  }
                },
              ),
            ]
          : null,
    );
  }
}

class StatisticsPieChart<N extends num> extends StatelessWidget {
  const StatisticsPieChart({
    Key? key,
    required this.id,
    required this.domainLabels,
    required this.values,
    this.colours = const <Color>[],
    this.valueFormatter,
    this.onTap,
  }) : super(key: key);

  final String id;
  final List<String> domainLabels;
  final List<N> values;
  final List<Color> colours;
  final String Function(String, N)? valueFormatter;
  final void Function(int)? onTap;

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

    final charts.Color outsideTextColour = charts.ColorUtil.fromDartColor(
      AppTheme.defaultThemeTextColor(context),
    );

    final charts.Series<_SeriesElement<N>, String> series =
        charts.Series<_SeriesElement<N>, String>(
      id: id,
      colorFn: (_SeriesElement<N> element, __) =>
          charts.ColorUtil.fromDartColor(
        colours.isEmpty
            ? Theme.of(context).primaryColor
            : colours.elementAt(element.index),
      ),
      domainFn: (_SeriesElement<N> element, _) => element.domainLabel,
      measureFn: (_SeriesElement<N> element, _) => element.value,
      data: data,
      labelAccessorFn: (_SeriesElement<N> element, _) => element.value > 0
          ? labelAccessor(element.domainLabel, element.value)
          : '',
      outsideLabelStyleAccessorFn: (_, __) =>
          charts.TextStyleSpec(color: outsideTextColour),
    );

    final List<charts.Series<_SeriesElement<N>, String>> seriesList =
        <charts.Series<_SeriesElement<N>, String>>[series];

    return charts.PieChart<String>(
      seriesList,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig<String>(
        arcWidth: 100,
        // ignore: always_specify_types
        arcRendererDecorators: [
          charts.ArcLabelDecorator<String>(),
        ],
      ),
      selectionModels: onTap != null
          ? <charts.SelectionModelConfig<String>>[
              charts.SelectionModelConfig<String>(
                updatedListener: (charts.SelectionModel<String> model) {
                  final charts.SeriesDatum<String>? firstDatum =
                      model.selectedDatum.firstOrNull;
                  if (firstDatum != null && firstDatum.index != null) {
                    final int domainIndex = firstDatum.index!;
                    onTap!(domainIndex);
                  }
                },
              ),
            ]
          : null,
    );
  }
}

class _SeriesElement<N extends num> {
  const _SeriesElement(this.index, this.domainLabel, this.value);

  final int index;
  final String domainLabel;
  final N value;
}
