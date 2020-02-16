import 'dart:math';

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

    return Scrollbar(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 40.0,
              maxHeight: 40.0,
              child: Container(
                child: Center(
                  child: Text(activeView, style: Theme.of(context).textTheme.subhead,),
                ),
                color: Colors.grey,
              )
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              items.map( (CollectionItem item) {
                return DismissibleItem(
                  item: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ItemDetailBuilder(item);
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
              }).toList(),
            ),
          ),
        ],
      ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  
  final double minHeight;
  final double maxHeight;
  final Widget child;
  
  @override
  double get minExtent => minHeight;
  
  @override
  double get maxExtent => max(maxHeight, minHeight);
  
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }  @override
  
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}