import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show GameTimeLog;
import 'package:backend/model/calendar_range.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/statistics_histogram.dart';


class CalendarUtils {
  CalendarUtils._();

  static Widget buildTimeLogsGraph(BuildContext context, List<GameTimeLog> timeLogs, CalendarRange range) {
    if(timeLogs.isEmpty) {
      return Center(
        child: Text(GameCollectionLocalisations.of(context).emptyTimeLogsString),
      );
    }

    List<int> values = <int>[];
    List<String> labels = <String>[];

    if(range == CalendarRange.Day) {
      // Create list where each entry is the time in an hour
      values = List<int>.filled(24, 0, growable: false);
      timeLogs.forEach( (GameTimeLog log) {
        int currentHour = log.dateTime.hour;
        final int pendingMinToChangeHour = 60 - log.dateTime.minute;
        final int logMin = log.time.inMinutes;

        if(pendingMinToChangeHour > logMin) {
          // Not enough time to change hour, put the whole log time
          values[currentHour] = logMin;
        } else {
          // Enough time, put time to change hour
          values[currentHour] = pendingMinToChangeHour;

          // Now compute for next hours
          int leftMin = logMin - pendingMinToChangeHour;
          while(leftMin > 0) {
            currentHour++;

            if(60 >= leftMin) {
              // Less than an hour left, put whole time left
              values[currentHour] = leftMin;

              leftMin = 0;
            } else {
              // More than an hour left, put hour and continue for next hours
              values[currentHour] = 60;

              leftMin -= 60;
            }
          }
        }
      });

      // TODO: Only show labels for 6, 12 and 18 hours
      labels = List<String>.generate(24, (int index) {
        return '$index:00';
      });
    } else {
      values = timeLogs.map<int>( (GameTimeLog log) {
        return log.time.inMinutes;
      }).toList(growable: false);

      if(range == CalendarRange.Week) {
        labels = GameCollectionLocalisations.of(context).shortDaysOfWeek;
      } else if(range == CalendarRange.Month) {
        labels = List<String>.generate(values.length, (int index) => (index + 1).toString());
      } else if(range == CalendarRange.Year) {
        labels = GameCollectionLocalisations.of(context).shortMonths;
      }
    }

    if(range == CalendarRange.Day || range == CalendarRange.Month) {

      return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 2,
            child: StatisticsHistogram<int>(
              histogramName: GameCollectionLocalisations.of(context).timeLogsFieldString,
              domainLabels: labels,
              values: values,
              vertical: true,
              hideDomainLabels: false,
              valueFormatter: (int value) => GameCollectionLocalisations.of(context).durationString(Duration(minutes: value)),
            ),
          ),
        ],
      );

    } else {

      return Container(
        child: StatisticsHistogram<int>(
          histogramName: GameCollectionLocalisations.of(context).timeLogsFieldString,
          domainLabels: labels,
          values: values,
          vertical: true,
          hideDomainLabels: false,
          valueFormatter: (int value) => GameCollectionLocalisations.of(context).durationString(Duration(minutes: value)),
        ),
      );

    }
  }
}