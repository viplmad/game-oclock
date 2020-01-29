import 'dart:math';

import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_connector.dart';
import 'package:game_collection/persistence/db_manager.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart' as gameEntity;
import 'package:game_collection/entity/dlc.dart' as dlcEntity;
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;
import 'package:game_collection/entity/store.dart' as storeEntity;
import 'package:game_collection/entity/platform.dart' as platformEntity;

import 'package:game_collection/loading_icon.dart';
import 'package:game_collection/show_snackbar.dart';


const _addedMessage = "Added";
const _failedAddMessage = "Unable to add";
const _deletedMessage = "Deleted";
const _failedDeleteMessage = "Unable to delete";

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with TickerProviderStateMixin<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final IDBConnector _db = DBManager().getDBConnector();

  int _selectedIndex = 0;

  void _showSnackBar(String message){

    showSnackBar(
      scaffoldState: scaffoldKey.currentState,
      message: message,
    );

  }

  bool _isUpdating = false;

  void startUpdate() {
    setState(() {
      _isUpdating = true;
    });
  }
  void endUpdate() {
    setState(() {
      _isUpdating = false;
    });
  }
  bool isUpdating() { return _isUpdating; }
  void handleUpdate({@required Future<dynamic> Function() insertFuture}) {

    startUpdate();

    insertFuture().then( (dynamic data) {

      setState(() {});
      _showSnackBar(_addedMessage);

    }, onError: (e) {

      _showSnackBar(_failedAddMessage);

    }).whenComplete( () {
      endUpdate();
    });

  }

  Function() _onUpdate({@required Future<dynamic> Function() insertFuture}) {

    return isUpdating()?
        null
        :
        () {
          handleUpdate(
            insertFuture: insertFuture,
          );
        };

  }

  List<List<String>> _barSortFields;

  List<BarItem> _barItems;
  List<Key> _destinationKeys;
  List<AnimationController> _faders;

  @override
  void initState() {
    super.initState();


    _barItems = [
      BarItem(
        title: gameEntity.gameTable,
        icon: Icons.videogame_asset,
        color: gameEntity.gameColour,
        fields: gameEntity.gameFields,
        allStream: ([List<String> sortFields = const [gameEntity.releaseYearField, gameEntity.nameField]]) => _db.getAllGames(sortFields),
        insertFuture: () => _db.insertGame('', ''),
        deleteFuture: (int deletedGameID) => _db.deleteGame(deletedGameID),
      ),
      BarItem(
        title: dlcEntity.dlcTable,
        icon: Icons.widgets,
        color: dlcEntity.dlcColour,
        fields: dlcEntity.dlcFields,
        allStream: ([List<String> sortFields = const [dlcEntity.releaseYearField, dlcEntity.nameField]]) => _db.getAllDLCs(sortFields),
        insertFuture: () => _db.insertDLC(''),
        deleteFuture: (int deletedDLCID) => _db.deleteDLC(deletedDLCID),
      ),
      BarItem(
        title: purchaseEntity.purchaseTable,
        icon: Icons.local_grocery_store,
        color: purchaseEntity.purchaseColour,
        fields: purchaseEntity.purchaseFields,
        allStream: ([List<String> sortFields = const [purchaseEntity.dateField, purchaseEntity.descriptionField]]) => _db.getAllPurchases(sortFields),
        insertFuture: () => _db.insertPurchase(''),
        deleteFuture: (int deletedPurchaseID) => _db.deletePurchase(deletedPurchaseID),
      ),
      BarItem(
        title: storeEntity.storeTable,
        icon: Icons.store,
        color: storeEntity.storeColour,
        fields: storeEntity.storeFields,
        allStream: ([List<String> sortFields = const [storeEntity.nameField]]) => _db.getAllStores(sortFields),
        insertFuture: () => _db.insertStore(''),
        deleteFuture: (int deletedStoreID) => _db.deleteStore(deletedStoreID),
      ),
      BarItem(
        title: platformEntity.platformTable,
        icon: Icons.phonelink,
        color: platformEntity.platformColour,
        fields: platformEntity.platformFields,
        allStream: ([List<String> sortFields = const [platformEntity.typeField, platformEntity.nameField]]) => _db.getAllPlatforms(sortFields),
        insertFuture: () => _db.insertPlatform(''),
        deleteFuture: (int deletedPlatformID) => _db.deletePlatform(deletedPlatformID),
      ),
    ];
    _barSortFields = _barItems.map<List<String>>( (BarItem item) {
      return [];
    }).toList(growable: false);

    //implementation of fade in, fade out
    _faders = _barItems.map<AnimationController>((dynamic data) {
      return AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[_selectedIndex].value = 1.0;
    _destinationKeys = List<Key>.generate(_barItems.length, (int index) => GlobalKey()).toList();

  }

  @override
  Widget build(BuildContext context) {

    List<BottomNavigationBarItem> _barNavItems = _barItems.map<BottomNavigationBarItem>( (BarItem item) {
      return BottomNavigationBarItem(
        title: Text(item.title + 's'),
        icon: Icon(item.icon),
        backgroundColor: item.color,
      );
    }).toList(growable: false);

    List<FloatingActionButton> _barFABs = _barItems.map<FloatingActionButton>( (BarItem item) {
      return FloatingActionButton(
        onPressed: _onUpdate(
          insertFuture: item.insertFuture,
        ),
        tooltip: 'New ' + item.title,
        child: Icon(Icons.add),
        backgroundColor: item.color,
      );
    }).toList(growable: false);

    List<Widget> _barStackBodies = _barItems.map<Widget>((BarItem item) {
      int barIndex = _barItems.indexOf(item);

      final Widget view = FadeTransition(
        opacity: _faders[barIndex].drive(CurveTween(curve: Curves.fastOutSlowIn)),
        child: KeyedSubtree(
          key: _destinationKeys[barIndex],
          child: EntityList(
            entityStream: _barSortFields[barIndex].isNotEmpty? item.allStream(_barSortFields[barIndex]) : item.allStream(),
            deleteFuture: item.deleteFuture,
          ),
        ),
      );
      if (barIndex == _selectedIndex) {
        _faders[barIndex].forward();
        return view;
      } else {
        _faders[barIndex].reverse();
        if (_faders[barIndex].isAnimating) {
          return IgnorePointer(child: view);
        }
        return Offstage(child: view);
      }
    }).toList(growable: false);

    List<IconButton> _barSortIcons = _barItems.map<IconButton>((BarItem item) {
      int barIndex = _barItems.indexOf(item);

      return IconButton(
        icon: Icon(Icons.sort),
        tooltip: 'Sort',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {

              return ReorderableSortList(
                title: item.title,
                getSortFields: () {
                  return _barSortFields.elementAt(barIndex);
                },
                allFields: item.fields,
              );

            },
          );
        },
      );

    }).toList(growable: false);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(_barItems.elementAt(_selectedIndex).title + 's'),
        backgroundColor: _barItems.elementAt(_selectedIndex).color,
        actions: <Widget>[
          _barSortIcons.elementAt(_selectedIndex),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: _barStackBodies,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        items: _barNavItems,
        onTap: (int selectedIndex) {
          setState(() {
            _selectedIndex = selectedIndex;
          });
        },
      ),
      floatingActionButton: _barFABs.elementAt(_selectedIndex),
    );
  }
}

class EntityList extends StatefulWidget {
  EntityList({Key key, @required this.entityStream, @required this.deleteFuture}) : super(key: key);

  final Stream<List<Entity>> entityStream;
  final Future<dynamic> Function(int) deleteFuture;

  @override
  State<EntityList> createState() => _EntityListState();
}
class _EntityListState extends State<EntityList> {

  void _showSnackBar(String message){

    showSnackBar(
      scaffoldState: Scaffold.of(context),
      message: message,
    );

  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: widget.entityStream,
      builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<Entity> results = snapshot.data;

        return Scrollbar(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index) {
              Entity result = results[index];

              return result.getDismissibleCard(
                context: context,
                handleConfirm: () {
                  return showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Delete"),
                        content: ListTile(
                          title: Text("Are you sure you want to delete " + result.getFormattedTitle() + "?"),
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
                    },
                  );
                },
                handleDelete: () {
                  widget.deleteFuture(result.ID).then( (dynamic data) {

                    _showSnackBar(_deletedMessage + " " + result.getFormattedTitle());

                  }, onError: (e) {

                    _showSnackBar(_failedDeleteMessage + " " + result.getFormattedTitle());

                  });
                },
              );
            },
          ),
        );
      },

    );

  }

}

class BarItem {
  const BarItem({@required this.title, this.color, @required this.icon, @required this.fields, @required this.allStream, @required this.insertFuture, @required this.deleteFuture});

  final String title;
  final IconData icon;
  final Color color;
  final List<String> fields;
  final Stream<List<Entity>> Function([List<String> sortFields]) allStream;
  final Future<dynamic> Function() insertFuture;
  final Future<dynamic> Function(int) deleteFuture;
}

class ReorderableSortList extends StatefulWidget {
  ReorderableSortList({Key key, @required this.title, @required this.getSortFields, @required this.allFields}) : super(key: key);

  final String title;
  final List<String> Function() getSortFields;
  final List<String> allFields;

  State<ReorderableSortList> createState() => _ReorderableSortListState();
}
class _ReorderableSortListState extends State<ReorderableSortList> {

  List<String> _copy;

  @override
  void initState() {
    super.initState();

    _copy = List.from(widget.getSortFields());
    _copy.addAll( widget.allFields.skipWhile( (String field) {
      return widget.getSortFields().contains(field);
    }) );
  }

  void swap(List<String> list, int oldIndex, int newIndex) {

    if (oldIndex == newIndex) {
      return;
    }
    String _temp = list.removeAt(oldIndex);
    list.insert(newIndex, _temp);

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ReorderableListView(
        children: _copy.map<Widget>( (String field) {
          return CheckboxListTile(
            key: ValueKey(widget.title + field),
            title: Text(field),
            value: widget.getSortFields().contains(field),
            onChanged: (bool isSelected) {
              if(isSelected) {
                int _oldIndex = _copy.indexOf(field);
                int _lastAvailableIndex = widget.getSortFields().length;
                swap(_copy, _oldIndex, _lastAvailableIndex);
                setState(() {
                  widget.getSortFields().add(field);
                });
              } else {
                int _oldIndex = _copy.indexOf(field);
                int _lastSelectedIndex = widget.getSortFields().length-1;
                swap(_copy, _oldIndex, _lastSelectedIndex);
                setState(() {
                  widget.getSortFields().remove(field);
                });
              }
            },
          );
        }).toList(),
        onReorder: (int oldIndex, int newIndex) {
          if(oldIndex < newIndex) {
            newIndex--;
          }
          String field = _copy.elementAt(oldIndex);
          if(widget.getSortFields().contains(field)) {
            newIndex = min(newIndex, widget.getSortFields().length-1);
            setState(() {
              swap(widget.getSortFields(), oldIndex, newIndex);
            });
          } else {
            newIndex = max(newIndex, widget.getSortFields().length);
          }
          swap(_copy, oldIndex, newIndex);
        },
      ),
    );

  }
}