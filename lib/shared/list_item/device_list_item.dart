import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/models/models.dart' show Device;

class DeviceTileListItem extends StatelessWidget {
  const DeviceTileListItem({super.key, required this.data, this.onTap});

  final Device data;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(title: data.name, onTap: onTap);
  }
}
