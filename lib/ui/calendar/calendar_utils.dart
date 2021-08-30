import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show GameTimeLog;
import 'package:backend/model/calendar_range.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/statistics_histogram.dart';


class CalendarUtils {
  CalendarUtils._();

  static Widget buildTimeLogsGraph(BuildContext context, List<GameTimeLog> timeLogs, CalendarRange range) {
    List<int> values = <int>[];
    List<String> labels = <String>[];
    double heightFactor = 1.5;

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

      // Only show labels for 6, 12 and 18 hours
      labels = List<String>.generate(24, (int index) {
        if(index == 6 || index == 12 || index == 18) {
          return '$index:00';
        }

        return '$index';
      });

      heightFactor = 1;
    } else {
      values = timeLogs.map<int>( (GameTimeLog log) {
        return log.time.inMinutes;
      }).toList(growable: false);

      if(range == CalendarRange.Week) {
        labels = GameCollectionLocalisations.of(context).shortDaysOfWeek;

        heightFactor = 1.5;
      } else if(range == CalendarRange.Month) {
        labels = List<String>.generate(values.length, (int index) => (index + 1).toString());

        heightFactor = 1;
      } else if(range == CalendarRange.Year) {
        labels = GameCollectionLocalisations.of(context).shortMonths;

        heightFactor = 1.5;
      }
    }

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / heightFactor,
          child: StatisticsHistogram<int>(
            histogramName: GameCollectionLocalisations.of(context).timeLogsFieldString,
            domainLabels: labels,
            values: values,
            vertical: false,
            hideDomainLabels: false,
            valueFormatter: (int value) => GameCollectionLocalisations.of(context).durationString(Duration(minutes: value)),
          ),
        ),
      ],
    );
  }
}