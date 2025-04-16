import 'package:flutter/material.dart';

final List<NavigationDestination> mainDestinations = List.unmodifiable([
  const NavigationDestination(icon: Icon(Icons.abc), label: '1'),
  const NavigationDestination(icon: Icon(Icons.app_blocking), label: '2'),
  const NavigationDestination(icon: Icon(Icons.account_balance), label: '3'),
]);

final List<NavigationDestination> secondaryDestinations = List.unmodifiable([
  const NavigationDestination(icon: Icon(Icons.one_x_mobiledata), label: 'x'),
  const NavigationDestination(icon: Icon(Icons.yard), label: 'y'),
  const NavigationDestination(icon: Icon(Icons.zoom_in), label: 'z'),
]);
