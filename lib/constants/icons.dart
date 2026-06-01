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
  static const clearInline = Icon(Icons.cancel_outlined);
  static const addInline = Icon(Icons.add_circle_outline);
  static const back = Icon(Icons.arrow_back);
  static const listStyleTile = Icon(Icons.list);
  static const listStyleGrid = Icon(Icons.grid_on);
  static const yes = Icon(Icons.check);
  static const no = Icon(Icons.close);
  static const ascending = Icon(Icons.arrow_upward);
  static const descending = Icon(Icons.arrow_downward);
  static const theme = Icon(Icons.brightness_6_outlined);
  static const light = Icon(Icons.light_mode);
  static const dark = Icon(Icons.dark_mode);
  static const language = Icon(Icons.language);
  static const admin = Icon(Icons.shield);
  static const addSession = Icon(Icons.more_time);
  static const star = Icon(Icons.star);
  static Icon colorStar(final Color? color) => Icon(Icons.star, color: color);

  static const games = Icon(Icons.videogame_asset);
  static const wishlists = Icon(Icons.shopping_bag);
  static const dlcs = Icon(Icons.widgets);
  static const locations = Icon(Icons.shelves);
  static const devices = Icon(Icons.devices);
  static const tags = Icon(Icons.sell);
  static const playthroughs = Icon(Icons.playlist_play);
  static const users = Icon(Icons.group);
  static const settings = Icon(Icons.settings);

  static const calendar = Icon(Icons.calendar_month);
  static const datePicker = Icon(Icons.calendar_today);
  static const timePicker = Icon(Icons.schedule);
  static const durationPicker = Icon(Icons.timer);
  static const yearPicker = Icon(Icons.date_range_outlined);
  static const review = Icon(Icons.cake);
  static const session = Icon(Icons.schedule);
  static const finished = Icon(Icons.emoji_events_outlined);
  static const first = Icon(Icons.fiber_new_outlined);
  static const notFirst = Icon(Icons.history);
  static const notFirstFinished = Icon(Icons.event_repeat_outlined);
  static const longestSessionIcon = Icon(Icons.weekend_outlined);
  static const longestStreakIcon = Icon(Icons.local_fire_department_outlined);
  static const firstItem = Icon(Icons.looks_one_outlined);
  static const secondItem = Icon(Icons.looks_two_outlined);
  static const thirdItem = Icon(Icons.looks_3_outlined);
  static const fourthItem = Icon(Icons.looks_4_outlined);
  static const fifthItem = Icon(Icons.looks_5_outlined);
  static const chart = Icon(Icons.new_releases_outlined);
  static const genreChart = Icon(Icons.collections_bookmark);

  static const externalSourceDefault = Icon(Icons.cloud);
  static const externalSourceIgdb = ImageIcon(
    AssetImage('assets/icons/IgdbLogoBlack_small.png'),
    size: kIconSize,
  );
}
