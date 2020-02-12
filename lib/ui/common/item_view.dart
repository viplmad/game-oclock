import 'package:flutter/material.dart';

import 'package:game_collection/model/collection_item.dart';

class DismissibleItem extends StatelessWidget {

  DismissibleItem({Key key, @required this.item, @required this.onTap, @required this.onDismissed, this.dismissIcon = Icons.delete, this.confirmDismiss}) : super(key: key);

  final CollectionItem item;
  final void Function(DismissDirection direction) onDismissed;
  final void Function() onTap;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final IconData dismissIcon;

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

  const ItemCard({Key key, @required this.item, @required this.onTap}) : super(key: key);

  final CollectionItem item;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0),),
        child: ItemListTile(
          item: item,
        ),
        onTap: onTap,
      ),
    );
  }

}

class ItemListTile extends StatelessWidget {

  final CollectionItem item;

  const ItemListTile({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(item.getTitle()),
      subtitle: item.getSubtitle() != null?
      Text(item.getSubtitle())
          : null,
    );

  }

}

class FilterChipItem extends StatelessWidget {

  const FilterChipItem({Key key, this.item, this.selected = true, this.onTap}) : super(key: key);

  final CollectionItem item;
  final bool selected;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {

    return FilterChip(
      label: Text(item.getTitle()),
      selected: selected,
      onSelected: onTap,
    );

  }

}