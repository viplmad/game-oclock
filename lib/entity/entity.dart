import 'package:flutter/material.dart';

import 'package:game_collection/entity_view/entity_view.dart';

const String IDField = 'ID';

abstract class Entity {
  final int ID;

  EntityView entityView;

  Entity({@required this.ID});

  static Entity fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {}

  String getUniqueID() {

    return getClassID() + this.ID.toString();

  }
  external String getClassID();

  external String getFormattedTitle();

  String getFormattedSubtitle() {

    return null;

  }

  Image getImage() {

    return null;

  }

  Widget getListTile() {

    return ListTile(
      leading: this.getImage() != null?
          Hero(
            tag: this.getUniqueID() + 'image',
            child: FlutterLogo(),
          )
          :
          null,
      title: Hero(
        tag: this.getUniqueID() + 'text',
        child: Text(this.getFormattedTitle()),
        flightShuttleBuilder: (BuildContext flightContext, Animation<double> animation, HeroFlightDirection flightDirection, BuildContext fromHeroContext, BuildContext toHeroContext) {
          return DefaultTextStyle(
            style: DefaultTextStyle.of(toHeroContext).style,
            child: toHeroContext.widget,
          );
        },
      ),
      subtitle: this.getFormattedSubtitle() != null?
          Text(this.getFormattedSubtitle())
          :
          null,
    );

  }

  Widget getDismissibleCard({@required BuildContext context, Function onTap, void Function() handleDelete, Future<bool> Function() handleConfirm, IconData deleteIcon = Icons.delete}) {

    return Dismissible(
      key: ValueKey(getUniqueID()),
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Icon(deleteIcon, color: Colors.white,),
              Icon(deleteIcon, color: Colors.white,),
            ],
          ),
        )
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
      color: this.getColour()?.withOpacity(0.5),
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

  external Widget entityBuilder(BuildContext context);

  Color getColour() {

    return null;

  }

}