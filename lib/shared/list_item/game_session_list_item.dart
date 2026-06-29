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
          if (data.started)
            Tooltip(
              message: context.localize().startedLabel,
              child: CommonIcons.first,
            ),
          if (data.finishedStatus != null)
            Tooltip(
              message: context.localize().finishedLabel,
              child: CommonIcons.finished,
            ),
        ],
      ),
      onTap: onTap,
      hasImage: false,
    );
  }
}

class SessionWithMediaTileListItem extends StatelessWidget {
  const SessionWithMediaTileListItem({
    super.key,
    required this.data,
    this.selectedDay,
    required this.onTap,
  });

  final MediaSessionDTO data;
  final DateTime? selectedDay;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.media.media.edition.isEmpty
          ? data.media.media.title
          : context.localize().gameEditionDataTitle(
              data.media.media.title,
              data.media.media.edition,
            ),
      subtitle:
          '${_buildTitle(context, data.session, selectedDay)} · ${context.localize().formatDuration(data.session.time)}',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (data.session.started)
            Tooltip(
              message: context.localize().startedLabel,
              child: CommonIcons.first,
            ),
          if (data.session.finishedStatus != null)
            Tooltip(
              message: context.localize().finishedLabel,
              child: CommonIcons.finished,
            ),
        ],
      ),
      imageURL: data.media.media.imageUrl,
      onTap: onTap,
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
