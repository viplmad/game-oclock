import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart';

List<String> monthLabels = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];


abstract class ItemStatistics extends StatelessWidget {
  const ItemStatistics({Key key, @required this.itemName}) : super(key: key);

  final String itemName;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(this.itemName),
      ),
      body: ListView(
        children: [
          Column(
            children: statisticsFieldsBuilder(context),
          ),
        ],
      ),
    );

  }

  Widget statisticsIntField({@required String fieldName, @required int value, int total}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: value.toString(),
      percentage: (total != null && total > 0)?
        (value / total) * 100
        :
        null,
    );

  }

  Widget statisticsDurationField({@required String fieldName, @required Duration value}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: value != null?
        value.inHours.toString() + ":" + (value.inMinutes - (value.inHours * 60)).toString().padLeft(2, '0')
        :
        "",
    );

  }

  Widget statisticsMoneyField({@required String fieldName, @required double value, double total}) {

    return StatisticsField(
      fieldName: fieldName,
      shownValue: value.toStringAsFixed(2) + ' €',
      percentage: (total != null && total > 0)?
        (value / total) * 100
        :
        null,
    );

  }

  Widget statisticsGroupField({@required String groupName, @required List<StatisticsField> fields}) {

    return StatisticsFieldGroup(
      groupName: groupName,
      fields: fields,
    );

  }

  Widget statisticsHistogram({@required double height, @required String histogramName, @required List<String> labels, @required List<int> values, List<StatisticsField> Function() trailingBuilder}) {

    return ListTile(
      title: Text(histogramName),
      subtitle: Container(
        height: height,
        child: StatisticsHistogram(
          histogramName: histogramName,
          labels: labels,
          values: values,
        ),
      ),
    );

  }

  external List<Widget> statisticsFieldsBuilder(BuildContext context);

}

class StatisticsField extends StatelessWidget {

  const StatisticsField({Key key, @required this.fieldName, @required this.shownValue, this.percentage}) : super(key: key);

  final String fieldName;
  final String shownValue;
  final double percentage;

  String get shownPercentage => ((percentage != null && !percentage.isNaN)? ' - ' + percentage.toStringAsFixed(2) + ' %' : '');

  @override
  Widget build(BuildContext context) {

    return ListTileTheme.merge(
      child: ListTile(
        title: Text(fieldName),
        trailing: Text((shownValue?? "Unknown") + shownPercentage),
      ),
    );

  }

}

class StatisticsFieldGroup extends StatelessWidget {

  const StatisticsFieldGroup({Key key, @required this.groupName, @required this.fields}) : super(key: key);

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

class StatisticsHistogram extends StatelessWidget {

  const StatisticsHistogram({Key key, @required this.histogramName, @required this.labels, @required this.values, this.trailingBuilder}) : super(key: key);

  final String histogramName;
  final List<String> labels;
  final List<int> values;
  final List<StatisticsField> Function() trailingBuilder;

  @override
  Widget build(BuildContext context) {
    List<SeriesElement> data = [];

    for(int index = 0; index < labels.length; index++) {
      String currentLabel =  labels.elementAt(index);
      int currentValue = values.elementAt(index);

      SeriesElement seriesEle = SeriesElement(currentLabel, currentValue);
      data.add(seriesEle);
    }

    final Series<SeriesElement, String> series = Series<SeriesElement, String>(
      id: histogramName,
      colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
      domainFn: (SeriesElement element, index) => element.label,
      measureFn: (SeriesElement element, index) => element.value,
      data: data,
    );

    final List<Series<SeriesElement, String>> seriesList = [
      series
    ];

    return BarChart(
      seriesList,
      animate: true,
    );
  }

}
class SeriesElement {
  final String label;
  final int value;

  SeriesElement(this.label, this.value);
}