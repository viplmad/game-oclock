import 'package:flutter/material.dart';

import 'package:game_collection/model/collection_item.dart';

class DismissibleItem extends StatelessWidget {

  final CollectionItem item;
  final void Function(DismissDirection direction) onDismissed;
  final void Function() onTap;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final IconData dismissIcon;

  DismissibleItem({Key key, @required this.item, @required this.onTap, @required this.onDismissed, this.dismissIcon = Icons.delete, this.confirmDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(item.ID),
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
      child: ItemCard(
        item: item,
        onTap: onTap,
      ),
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
    );

  }

}

class ItemCard extends StatelessWidget {

  final CollectionItem item;
  final void Function() onTap;

  const ItemCard({Key key, @required this.item, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0),),
        child: EntityListTile(
          entity: item,
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