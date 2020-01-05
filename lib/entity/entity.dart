import 'package:flutter/material.dart';

const String IDField = 'ID';

abstract class Entity {
  final int ID;

  Entity({@required this.ID});
}