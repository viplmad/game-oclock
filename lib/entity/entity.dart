import 'package:flutter/material.dart';

const String IDField = 'ID';

abstract class Entity {
  final int ID;

  Entity({@required this.ID});

  Widget getEssentialInfo();

  Widget getCard(BuildContext context, {Function handleDelete});
}