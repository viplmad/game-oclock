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

  final DBConnector _db = DBManager().getConnector();

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
        allStream: _db.getAllGames(),
        insertFuture: () => _db.insertGame('', ''),
        deleteFuture: (int deletedGameID) => _db.deleteGame(deletedGameID),
      ),
      BarItem(
        title: dlcEntity.dlcTable,
        icon: Icons.widgets,
        color: dlcEntity.dlcColour,
        allStream: _db.getAllDLCs(),
        insertFuture: () => _db.insertDLC(''),
        deleteFuture: (int deletedDLCID) => _db.deleteDLC(deletedDLCID),
      ),
      BarItem(
        title: purchaseEntity.purchaseTable,
        icon: Icons.local_grocery_store,
        color: purchaseEntity.purchaseColour,
        allStream: _db.getAllPurchases(),
        insertFuture: () => _db.insertPurchase(''),
        deleteFuture: (int deletedPurchaseID) => _db.deletePurchase(deletedPurchaseID),
      ),
      BarItem(
        title: storeEntity.storeTable,
        icon: Icons.store,
        color: storeEntity.storeColour,
        allStream: _db.getAllStores(),
        insertFuture: () => _db.insertStore(''),
        deleteFuture: (int deletedStoreID) => _db.deleteStore(deletedStoreID),
      ),
      BarItem(
        title: platformEntity.platformTable,
        icon: Icons.phonelink,
        color: platformEntity.platformColour,
        allStream: _db.getAllPlatforms(),
        insertFuture: () => _db.insertPlatform(''),
        deleteFuture: (int deletedPlatformID) => _db.deletePlatform(deletedPlatformID),
      ),
    ];

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
            entityStream: item.allStream,
            deleteFuture: item.deleteFuture,
          ),
        ),
      );
      if (barIndex== _selectedIndex) {
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

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(_barItems.elementAt(_selectedIndex).title + 's'),
        backgroundColor: _barItems.elementAt(_selectedIndex).color,
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
  const BarItem({@required this.title, this.color, @required this.icon, @required this.allStream, @required this.insertFuture, @required this.deleteFuture});

  final String title;
  final IconData icon;
  final Color color;
  final Stream<List<Entity>> allStream;
  final Future<dynamic> Function() insertFuture;
  final Future<dynamic> Function(int) deleteFuture;
}