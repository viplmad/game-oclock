import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/ui/common/item_view.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/app_tab.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import 'detail/detail.dart';

class ItemList extends StatelessWidget {

  ItemList({Key key, @required this.items, @required this.itemDetailBloc, @required this.activeTab}) : super(key: key);

  final List<CollectionItem> items;
  final ItemDetailBloc itemDetailBloc;
  final AppTab activeTab;

  ItemBloc get itemBloc => itemDetailBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    return Scrollbar(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          CollectionItem result = items[index];

          return DismissibleItem(
            item: result,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    switch(activeTab) {
                      case AppTab.game:
                        return GameDetail(
                          ID: result.ID,
                          itemDetailBloc: itemDetailBloc,
                        );
                      case AppTab.dlc:
                        return DLCDetail(
                          ID: result.ID,
                          itemDetailBloc: itemDetailBloc,
                        );
                      case AppTab.purchase:
                        /*return PurchaseDetail(
                          ID: result.ID,
                          itemDetailBloc: itemDetailBloc,
                        );*/
                      case AppTab.store:
                        /*return StoreDetail(
                          ID: result.ID,
                          itemDetailBloc: itemDetailBloc,
                        );*/
                      case AppTab.platform:
                        /*return PlatformDetail(
                          ID: result.ID,
                          itemDetailBloc: itemDetailBloc,
                        );*/
                    }
                    return Center();
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