import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

class SessionTileListItem extends StatelessWidget {
  const SessionTileListItem({
    super.key,
    required this.data,
    this.selectedDay,
    required this.onTap,
  });

  final SessionDTO data;
  final DateTime? selectedDay;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: _buildTitle(context, data, selectedDay),
      subtitle: context.localize().formatDuration(data.time),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (data.started) CommonIcons.first,
          if (data.finishedStatus != null) CommonIcons.finished,
        ],
      ),
      onTap: onTap,
      hasImage: false,
    );
  }
}

class GameSessionTileListItem extends StatelessWidget {
  const GameSessionTileListItem({
    super.key,
    required this.data,
    this.selectedDay,
    required this.onTap,
  });

  final SessionDTO data; // TODO with media
  final DateTime? selectedDay;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: _buildTitle(context, data, selectedDay),
      subtitle: context.localize().formatDuration(data.time),
      onTap: onTap,
      hasImage: false,
    );
  }
}

String _buildTitle(
  final BuildContext context,
  final SessionDTO data,
  final DateTime? selectedDay,
) {
  if (selectedDay == null) {
    return '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.startDatetime))} ⮕ ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.endDatetime))}';
  }

  if (data.startDatetime.isSameDay(selectedDay) &&
      data.endDatetime.isSameDay(selectedDay)) {
    return '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.startDatetime))} ⮕ ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.endDatetime))}';
  } else if (data.startDatetime.isSameDay(selectedDay)) {
    final endedAfterDays = data.endDatetime.daysDifference(selectedDay);
    return '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.startDatetime))} ⮕ (${context.localize().nextDaysLabel(endedAfterDays)}) ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.endDatetime))}';
  } else if (data.endDatetime.isSameDay(selectedDay)) {
    final startedBeforeDays = selectedDay.daysDifference(data.startDatetime);
    return '(${context.localize().daysBeforeLabel(startedBeforeDays)}) ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.startDatetime))} ⮕ ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.endDatetime))}';
  } else {
    final startedBeforeDays = selectedDay.daysDifference(data.startDatetime);
    final endedAfterDays = data.endDatetime.daysDifference(selectedDay);
    return '(${context.localize().daysBeforeLabel(startedBeforeDays)}) ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.startDatetime))} ⮕ (${context.localize().nextDaysLabel(endedAfterDays)}) ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.endDatetime))}';
  }
}
