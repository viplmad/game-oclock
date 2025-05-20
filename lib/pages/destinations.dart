import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show NavDestination;

final List<NavDestination> mainDestinations = List.unmodifiable([
  const NavDestination(icon: Icon(Icons.abc), label: '1', path: '/a'),
  const NavDestination(icon: Icon(Icons.app_blocking), label: '2', path: '/b'),
  const NavDestination(
    icon: Icon(Icons.account_balance),
    label: '3',
    path: '/c',
  ),
]);

final List<NavDestination> secondaryDestinations = List.unmodifiable([
  const NavDestination(
    icon: Icon(Icons.one_x_mobiledata),
    label: 'x',
    path: '/x',
  ),
  const NavDestination(icon: Icon(Icons.yard), label: 'y', path: '/y'),
  const NavDestination(icon: Icon(Icons.zoom_in), label: 'z', path: '/z'),
]);
