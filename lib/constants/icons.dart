import 'package:flutter/material.dart';

import 'constants.dart';

class CommonIcons {
  CommonIcons._();

  static const show = Icon(Icons.visibility_off);
  static const hide = Icon(Icons.visibility);
  static const add = Icon(Icons.add);
  static const edit = Icon(Icons.edit);
  static const delete = Icon(Icons.delete);
  static const link = Icon(Icons.add_link);
  static const unlink = Icon(Icons.link_off);
  static const search = Icon(Icons.search);
  static const down = Icon(Icons.arrow_drop_down);
  static const drawer = Icon(Icons.menu);
  static const drawerOpen = Icon(Icons.menu_open);
  static const detail = Icon(Icons.info);
  static const view = Icon(Icons.visibility);
  static const left = Icon(Icons.chevron_left);
  static const right = Icon(Icons.chevron_right);
  static const reload = Icon(Icons.refresh);
  static const clear = Icon(Icons.cancel_outlined);
  static const listStyleTile = Icon(Icons.list);
  static const listStyleGrid = Icon(Icons.grid_on);
  static const yes = Icon(Icons.check);
  static const no = Icon(Icons.close);
  static const ascending = Icon(Icons.arrow_upward);
  static const descending = Icon(Icons.arrow_downward);
  static Icon star(final Color? color) => Icon(Icons.star, color: color);

  static const games = Icon(Icons.videogame_asset);
  static const wishlists = Icon(Icons.shopping_bag);
  static const dlcs = Icon(Icons.widgets);
  static const locations = Icon(Icons.shelves);
  static const devices = Icon(Icons.devices);
  static const tags = Icon(Icons.sell);

  static const calendar = Icon(Icons.calendar_month);
  static const datePicker = Icon(Icons.calendar_today);
  static const timePicker = Icon(Icons.schedule);
  static const durationPicker = Icon(Icons.timer);
  static const review = Icon(Icons.cake);

  static const externalSourceDefault = Icon(Icons.cloud);
  static const externalSourceIgdb = ImageIcon(
    AssetImage('assets/icons/IgdbLogoBlack_small.png'),
    size: kIconSize,
  );
}
