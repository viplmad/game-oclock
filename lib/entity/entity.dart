import 'package:flutter/material.dart';

import 'package:game_collection/entity_view/entity_view.dart';

const String IDField = 'ID';

abstract class Entity {
  final int ID;

  EntityView entityView;

  Entity({@required this.ID});

  static Entity fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {}

  String getFormattedTitle();

  String getFormattedSubtitle() {

    return null;

  }

  Widget getListTile() {

    return this.getFormattedSubtitle() == null?
        ListTile(
          title: Text(this.getFormattedTitle()),
        )
        :
        ListTile(
          title: Text(this.getFormattedTitle()),
          subtitle: Text(this.getFormattedSubtitle()),
        );

  }

  Widget getDismissibleCard({@required BuildContext context, Function onTap, void Function() handleDelete, Future<bool> Function() handleConfirm}) {

    return Dismissible(
      key: ValueKey(this.ID),
      background: Container(
        color: Colors.red,
      ),
      child: this.getCard(
          context: context,
          onTap: onTap,
      ),
      onDismissed: (DismissDirection direction) {
        handleDelete();
      },
      confirmDismiss: handleConfirm == null?
          null
          :
          (DismissDirection direction) {
            return handleConfirm();
          },
    );

  }

  Widget getCard({@required BuildContext context, Function onTap}) {

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0),),
        child: this.getListTile(),
        onTap: onTap?? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: this.entityBuilder,
            ),
          );
        },
      ),
    );

  }

  Widget entityBuilder(BuildContext context);

}