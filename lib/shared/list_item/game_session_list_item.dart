import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

class SessionTileListItem extends StatelessWidget {
  const SessionTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final SessionDTO data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title:
          '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.startDatetime))} ⮕ ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.endDatetime))}',
      subtitle: context.localize().formatDuration(data.time),
      onTap: onTap,
      hasImage: false,
    );
  }
}

class GameSessionTileListItem extends StatelessWidget {
  const GameSessionTileListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final SessionDTO data; // TODO with media
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title:
          '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.startDatetime))} ⮕ ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.endDatetime))}',
      subtitle: context.localize().formatDuration(data.time),
      onTap: onTap,
      hasImage: false,
    );
  }
}
