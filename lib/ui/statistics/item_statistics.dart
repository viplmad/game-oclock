import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart';

import 'package:backend/bloc/item_statistics/item_statistics.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/statistics_histogram.dart';
import '../common/year_picker_dialog.dart';


class StatisticsArguments<T> {
  const StatisticsArguments({
    required this.items,
    required this.viewTitle,
  });

  final List<T> items;
  final String viewTitle;
}

abstract class ItemStatistics<T extends CollectionItem, D extends ItemData<T>, K extends ItemStatisticsBloc<T, D>> extends StatelessWidget {
  const ItemStatistics({
    Key? key,
    required this.items,
    required this.viewTitle,
  }) : super(key: key);

  final List<T> items;
  final String viewTitle;

  @override
  Widget build(BuildContext context) {

    return BlocProvider<K>(
      create: (BuildContext context) {
        return statisticsBlocBuilder()..add(LoadGeneralItemStatistics());
      },
      child: statisticsBodyBuilder(),
    );

  }

  K statisticsBlocBuilder();

  ItemStatisticsBody<T, D, K> statisticsBodyBuilder();
}

abstract class ItemStatisticsBody<T extends CollectionItem, D extends ItemData<T>, K extends ItemStatisticsBloc<T, D>> extends StatelessWidget {
  const ItemStatisticsBody({
    Key? key,
    required this.viewTitle,
  }) : super(key: key);

  final String viewTitle;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(typesName(context) + ' - ' + viewTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.all_inbox),
            tooltip: GameCollectionLocalisations.of(context).generalString,
            onPressed: () {
              BlocProvider.of<K>(context).add(LoadGeneralItemStatistics());
            },
          ),
          BlocBuilder<K, ItemStatisticsState>(
            builder: (BuildContext context, ItemStatisticsState state) {
              int? selectedYear;
              if(state is ItemYearStatisticsLoaded<T, D>) {
                selectedYear = state.year;
              }

              return IconButton(
                icon: const Icon(Icons.date_range),
                tooltip: GameCollectionLocalisations.of(context).changeYearString,
                onPressed: () {
                  showDialog<int?>(
                    context: context,
                    builder: (BuildContext context) {
                      return YearPickerDialog(
                        year: selectedYear,
                      );
                    },
                  ).then( (int? year) {
                    if (year != null) {
                      BlocProvider.of<K>(context).add(LoadYearItemStatistics(year));
                    }
                  });
                },
              );

            },
          ),
        ],
      ),
      body: BlocBuilder<K, ItemStatisticsState>(
        builder: (BuildContext context, ItemStatisticsState state) {

          if(state is ItemGeneralStatisticsLoaded<T, D>) {

            return Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    leading: const Icon(Icons.all_inbox),
                    title: Text(GameCollectionLocalisations.of(context).generalString),
                  ),
                  color: Colors.grey,
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: statisticsGeneralFieldsBuilder(context, state.itemData),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

          }
          if(state is ItemYearStatisticsLoaded<T, D>) {

            return Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    leading: const Icon(Icons.date_range),
                    title: Text(fromYearTitle(context, state.year)),
                  ),
                  color: Colors.grey,
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: statisticsYearFieldsBuilder(context, state.itemData),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

          }

          return const LinearProgressIndicator();

        },
      ),
    );

  }

  StatisticsField statisticsIntField(BuildContext context, {required String fieldName, required int value, int? total}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: value.toString(),
      shownPercentage: (total != null && total > 0)?
        GameCollectionLocalisations.of(context).percentageString(((value / total) * 100))
        :
        null,
    );

  }

  StatisticsField statisticsDoubleField({required String fieldName, required double value}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: value.toStringAsFixed(2),
    );

  }

  StatisticsField statisticsDurationField(BuildContext context, {required String fieldName, required Duration value}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: GameCollectionLocalisations.of(context).durationString(value),
    );

  }

  StatisticsField statisticsMoneyField(BuildContext context, {required String fieldName, required double value, double? total}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: GameCollectionLocalisations.of(context).euroString(value),
      shownPercentage: (total != null && total > 0)?
        GameCollectionLocalisations.of(context).percentageString(((value / total) * 100))
        :
        null,
    );

  }

  StatisticsField statisticsPercentageField(BuildContext context, {required String fieldName, required double value}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: GameCollectionLocalisations.of(context).percentageString(value * 100),
    );

  }

  Widget statisticsGroupField({required String groupName, required List<StatisticsField> fields}) {

    return StatisticsFieldGroup(
      groupName: groupName,
      fields: fields,
    );

  }

  Widget statisticsHistogram<N extends num>({required double height, required String histogramName, required List<String> domainLabels, required List<N> values, bool vertical = true, bool hideDomainLabels = false, String Function(N)? labelAccessor}) {

    return ListTile(
      title: Text(histogramName),
      subtitle: SizedBox(
        height: height,
        child: StatisticsHistogram<N>(
          histogramName: histogramName,
          domainLabels: domainLabels,
          values: values,
          vertical: vertical,
          hideDomainLabels: hideDomainLabels,
          valueFormatter: labelAccessor,
        ),
      ),
    );

  }

  List<String> formatIntervalLabels<N extends num>(List<N> intervals, String Function(N) formatValue) {
    final List<String> labels = List<String>.filled(intervals.length - 1, '');
    int index = 0;

    for(int intervalIndex = 0; intervalIndex < intervals.length - 1; intervalIndex++) {
      final N min = intervals.elementAt(intervalIndex);
      final N max = intervals.elementAt(intervalIndex + 1);

      final String intervalLabel = _formatIntervalLabel<N>(min, max, formatValue);

      labels[index++] = intervalLabel;
    }

    return labels;
  }

  List<String> formatIntervalLabelsEqual<N extends num>(List<N> intervals, String Function(N) formatValue) {

    return intervals.map<String>(formatValue).toList(growable: false);

  }

  List<String> formatIntervalLabelsWithInitial<N extends num>(List<N> intervals, String Function(N) formatValue) {
    final List<String> labels = List<String>.filled(intervals.length, '');
    int index = 0;

    final String initialIntervalLabel = _formatIntervalInitialLabel<N>(intervals.first, formatValue);
    labels[index++] = initialIntervalLabel;

    for(int intervalIndex = 0; intervalIndex < intervals.length - 1; intervalIndex++) {
      final N min = intervals.elementAt(intervalIndex);
      final N max = intervals.elementAt(intervalIndex + 1);

      final String intervalLabel = _formatIntervalLabel<N>(min, max, formatValue);

      labels[index++] = intervalLabel;
    }

    return labels;
  }

  List<String> formatIntervalLabelsWithLast<N extends num>(List<N> intervals, String Function(N) formatValue) {
    final List<String> labels = List<String>.filled(intervals.length, '');
    int index = 0;

    for(int intervalIndex = 0; intervalIndex < intervals.length - 1; intervalIndex++) {
      final N min = intervals.elementAt(intervalIndex);
      final N max = intervals.elementAt(intervalIndex + 1);

      final String intervalLabel = _formatIntervalLabel<N>(min, max, formatValue);

      labels[index++] = intervalLabel;
    }

    final String lastIntervalLabel = _formatIntervalLastLabel<N>(intervals.last, formatValue);
    labels[index] = lastIntervalLabel;

    return labels;
  }

  List<String> formatIntervalLabelsWithInitialAndLast<N extends num>(List<N> intervals, String Function(N) formatValue) {
    final List<String> labels = List<String>.filled(intervals.length + 1, '');
    int index = 0;

    final String initialIntervalLabel = _formatIntervalInitialLabel<N>(intervals.first, formatValue);
    labels[index++] = initialIntervalLabel;

    for(int intervalIndex = 0; intervalIndex < intervals.length - 1; intervalIndex++) {
      final N min = intervals.elementAt(intervalIndex);
      final N max = intervals.elementAt(intervalIndex + 1);

      final String intervalLabel = _formatIntervalLabel<N>(min, max, formatValue);

      labels[index++] = intervalLabel;
    }

    final String lastIntervalLabel = _formatIntervalLastLabel<N>(intervals.last, formatValue);
    labels[index] = lastIntervalLabel;

    return labels;
  }

  String _formatIntervalLabel<N>(N min, N max, String Function(N) formatValue) {

    return formatValue(min) + '-' + formatValue(max);

  }

  String _formatIntervalInitialLabel<N>(N first, String Function(N) formatValue) {

    return formatValue(first);

  }

  String _formatIntervalLastLabel<N>(N last, String Function(N) formatValue) {

    return formatValue(last) + '+';

  }

  String typesName(BuildContext context);
  String fromYearTitle(BuildContext context, int year);

  List<Widget> statisticsGeneralFieldsBuilder(BuildContext context, D data);
  List<Widget> statisticsYearFieldsBuilder(BuildContext context, D data);
}

class StatisticsField extends StatelessWidget {
  const StatisticsField({
    Key? key,
    required this.fieldName,
    required this.shownValue,
    this.shownPercentage,
  }) : super(key: key);

  final String fieldName;
  final String shownValue;
  final String? shownPercentage;

  @override
  Widget build(BuildContext context) {

    return ListTileTheme.merge(
      child: ListTile(
        title: Text(fieldName),
        trailing: Text(shownValue + (shownPercentage != null? ' - ' + shownPercentage! : '')),
      ),
    );

  }
}

class StatisticsFieldGroup extends StatelessWidget {
  const StatisticsFieldGroup({
    Key? key,
    required this.groupName,
    required this.fields,
  }) : super(key: key);

  final String groupName;
  final List<StatisticsField> fields;

  @override
  Widget build(BuildContext context) {

    return ExpansionTile(
      title: Text(groupName),
      children: fields,
      initiallyExpanded: false,
    );

  }
}