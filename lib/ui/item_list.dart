import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/ui/bloc_provider_route.dart';

import 'common/item_view.dart';


class ItemList extends StatelessWidget {

  ItemList({Key key, @required this.items, @required this.activeView, @required this.onDismiss}) : super(key: key);

  final List<CollectionItem> items;
  final String activeView;
  final Function(CollectionItem) onDismiss;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            title: Text(activeView),
            trailing: IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search in View',
              onPressed: items.isNotEmpty? () {
                Navigator.push<CollectionItem>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ItemLocalSearchProvider(items);
                    }
                  ),
                );
              } : null,
            ),
          ),
          color: Colors.grey,
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                CollectionItem item = items[index];

                return DismissibleItem(
                  item: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ItemDetailProvider(item);
                        },
                      ),
                    );
                  },
                  onDismissed: (DismissDirection direction) {
                    onDismiss(item);
                  },
                  confirmDismiss: (DismissDirection direction) {

                    return showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return confirmDelete(context, item);
                      },
                    );

                  },
                );

              },
            ),
          ),
        ),
      ],
    );

  }

  Widget confirmDelete(BuildContext context, CollectionItem item) {

    return AlertDialog(
      title: Text("Delete"),
      content: ListTile(
        title: Text("Are you sure you want to delete " + item.getTitle() + "?"),
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