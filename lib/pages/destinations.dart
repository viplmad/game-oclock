import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart' show NavDestination;

final List<NavDestination> mainDestinations = List.unmodifiable([
  const NavDestination(
    icon: Icon(CommonIcons.games),
    label: 'Games',
    path: CommonPaths.gamesPath,
  ),
  const NavDestination(
    icon: Icon(CommonIcons.locations),
    label: 'Locations',
    path: CommonPaths.locationsPath,
  ),
  const NavDestination(
    icon: Icon(CommonIcons.devices),
    label: 'Devices',
    path: CommonPaths.devicesPath,
  ),
]);

final List<NavDestination> secondaryDestinations = List.unmodifiable([
  const NavDestination(
    icon: Icon(CommonIcons.calendar),
    label: 'Calendar',
    path: CommonPaths.calendarPath,
  ),
  const NavDestination(
    icon: Icon(CommonIcons.tags),
    label: 'Tags',
    path: CommonPaths.tagsPath,
  ),
  const NavDestination(
    icon: Icon(CommonIcons.devices),
    label: 'Users',
    path: CommonPaths.usersPath,
  ),
]);
