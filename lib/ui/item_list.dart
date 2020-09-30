import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/ui/bloc_provider_route.dart';

import 'common/item_view.dart';


class ItemList<T extends CollectionItem> extends StatelessWidget {

  ItemList({Key key, @required this.items, @required this.activeView, @required this.onDismiss, this.isGridView = true}) : super(key: key);

  final List<T> items;
  final String activeView;
  final Function(CollectionItem) onDismiss;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            title: Text(activeView),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  tooltip: 'Search in View',
                  onPressed: items.isNotEmpty? () {
                    Navigator.push<CollectionItem>(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ItemLocalSearchProvider<T>(items);
                        },
                      ),
                    );
                  } : null,
                ),
                IconButton(
                  icon: Icon(Icons.insert_chart),
                  tooltip: 'Stats in View',
                  onPressed: items.isNotEmpty? () {
                    Navigator.push<CollectionItem>(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ItemStatisticsProvider<T>(items, activeView);
                        },
                      ),
                    );
                  } : null,
                ),
              ],
            ),
          ),
          color: Colors.grey,
        ),
        Expanded(
          child: Scrollbar(
            child: isGridView?
              ItemGridView<T>(
                items: items,
                onTap: (T item) {
                  return () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ItemDetailProvider<T>(item);
                        },
                      ),
                    );
                  };
                },
              )
              :
              ItemListView<T>(
                items: items,
                onTap: (T item) {
                  return () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ItemDetailProvider<T>(item);
                        },
                      ),
                    );
                  };
                },
                onDismiss: onDismiss,
                confirmDelete: confirmDelete,
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

class ItemListView<T extends CollectionItem> extends StatelessWidget {

  const ItemListView({Key key, @required this.items, @required this.onTap, @required this.onDismiss, @required this.confirmDelete}) : super(key: key);

  final List<T> items;
  final void Function() Function(T item) onTap;
  final void Function(CollectionItem item) onDismiss;
  final Widget Function(BuildContext, CollectionItem) confirmDelete;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        T item = items[index];

        return DismissibleItem(
          item: item,
          onTap: onTap(item),
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
    );

  }
}

class ItemGridView<T extends CollectionItem> extends StatelessWidget {

  const ItemGridView({Key key, @required this.items, @required this.onTap}) : super(key: key);

  final List<T> items;
  final Function() Function(T item) onTap;

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        T item = items[index];

        return ItemGridCard(
          item: item,
          onTap: onTap(item),
        );

      },
    );

  }
}