import 'package:flutter/material.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show User;
import 'package:game_oclock/utils/localisation_extension.dart';

class UserTileListItem extends StatelessWidget {
  const UserTileListItem({super.key, required this.data, required this.onTap});

  final User data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TileListItem(
      title: data.username,
      trailing: data.isAdmin
          ? Tooltip(
              message: context.localize().adminLabel,
              child: CommonIcons.admin,
            )
          : null,
      onTap: onTap,
    );
  }
}
