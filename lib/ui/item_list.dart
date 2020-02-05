import 'package:flutter/material.dart';

import 'package:game_collection/ui/common/item_view.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'dlc_detail.dart';

class ItemList extends StatelessWidget {

  ItemList({Key key, @required this.items, @required this.itemBloc}) : super(key: key);

  final List<CollectionItem> items;
  final ItemBloc itemBloc;

  @override
  Widget build(BuildContext context) {

    return Scrollbar(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          CollectionItem result = items[index];

          return DismissibleEntity(
            entity: result,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return DLCDetail();
                  },
                ),
              );
            },
            onDismissed: (DismissDirection direction) {
              itemBloc.add(DeleteItem(result));
            },
            confirmDismiss: (DismissDirection direction) {

              return showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return confirmDelete(context, result);
                },
              );

            },
          );
        },
      ),
    );

  }

  Widget confirmDelete(BuildContext context, CollectionItem entity) {
    return AlertDialog(
      title: Text("Delete"),
      content: ListTile(
        title: Text("Are you sure you want to delete " + entity.getTitle() + "?"),
        subtitle: Text("This action cannot be undone"),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        RaisedButton(
          child: Text("Delete", style: TextStyle(color: Colors.white),),
          onPressed: () {
            Navigator.maybePop(context, true);
          },
          color: Colors.red,
        )
      ],
    );
  }

}