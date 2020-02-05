import 'package:flutter/material.dart';

import 'package:game_collection/model/collection_item.dart';

class DismissibleEntity extends StatelessWidget {

  final CollectionItem entity;
  final void Function(DismissDirection direction) onDismissed;
  final void Function() onTap;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final IconData dismissIcon;

  DismissibleEntity({Key key, @required this.entity, @required this.onTap, @required this.onDismissed, this.dismissIcon = Icons.delete, this.confirmDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(entity.ID),
      background: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                Icon(dismissIcon, color: Colors.white,),
                Icon(dismissIcon, color: Colors.white,),
              ],
            ),
          )
      ),
      child: EntityCard(
        entity: entity,
        onTap: onTap,
      ),
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
    );

  }

}

class EntityCard extends StatelessWidget {

  final CollectionItem entity;
  final void Function() onTap;

  const EntityCard({Key key, @required this.entity, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0),),
        child: EntityListTile(
          entity: entity,
        ),
        onTap: onTap,
      ),
    );
  }

}

class EntityListTile extends StatelessWidget {

  final CollectionItem entity;

  const EntityListTile({Key key, this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Hero(
        tag: entity.getUniqueID() + '_text',
        child: Text(entity.getTitle()),
        flightShuttleBuilder: (BuildContext flightContext, Animation<double> animation, HeroFlightDirection flightDirection, BuildContext fromHeroContext, BuildContext toHeroContext) {
          return DefaultTextStyle(
            style: DefaultTextStyle.of(toHeroContext).style,
            child: toHeroContext.widget,
          );
        },
      ),
      subtitle: entity.getSubtitle() != null?
      Text(entity.getSubtitle())
          : null,
    );

  }

}