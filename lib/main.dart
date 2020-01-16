import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/type.dart';
import 'package:game_collection/entity/purchase.dart';
import 'package:game_collection/entity/platform.dart';
import 'package:game_collection/entity/store.dart';
import 'package:game_collection/entity/system.dart';
import 'package:game_collection/entity/tag.dart';

import 'package:game_collection/loading_icon.dart';
import 'package:game_collection/start.dart';

void main() => runApp(GameCollection());

class GameCollection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Game Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const List<String> _barTitles = [
  "Games",
  "DLCs",
  "Purchases",
  "Stores",
  "Platforms",
];

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final DBConnector _db = PostgresConnector.getConnector();

  int _selectedScreen = 0;

  void _showSnackBar(String message){

    final snackBar = new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 3),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);

  }

  final List<BottomNavigationBarItem> _barItems = [
    BottomNavigationBarItem(
      title: Text(_barTitles[0]),
      icon: Icon(Icons.videogame_asset),
    ),
    BottomNavigationBarItem(
      title: Text(_barTitles[1]),
      icon: Icon(Icons.widgets),
    ),
    BottomNavigationBarItem(
      title: Text(_barTitles[2]),
      icon: Icon(Icons.local_grocery_store),
    ),
    BottomNavigationBarItem(
      title: Text(_barTitles[3]),
      icon: Icon(Icons.store),
    ),
    BottomNavigationBarItem(
      title: Text(_barTitles[4]),
      icon: Icon(Icons.phonelink),
    ),
  ];

  FloatingActionButton _getSelectedFAB(BuildContext context) {
    switch (_selectedScreen) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) =>
                  NewGame(scaffoldKey)
              ),
            );*/
          },
          tooltip: 'New Game',
          child: Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () {
            TextEditingController fieldController = TextEditingController();

            showModalBottomSheet<String>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 250,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: fieldController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Name',
                          ),
                        ),
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                        ),
                        FlatButton(
                          child: Text("Accept"),
                          onPressed: () {
                            Navigator.maybePop(context, fieldController.text);
                          },
                        )
                      ],
                    ),

                  );
                }
            ).then( (String nameOfNew) {
              if (nameOfNew != null && nameOfNew.trim().isNotEmpty) {
                _db.insertDLC(nameOfNew).then( (dynamic data) {

                  _showSnackBar("Added new DLC");

                }, onError: (e) {

                  _showSnackBar("Unable to add new DLC");

                });
              }
            });
          },
          tooltip: 'New DLC',
          child: Icon(Icons.add),
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            /*_db.insertPurchase().then( (dynamic data) {

              _showSnackBar("Added new purchase");

            }, onError: (e) {

              _showSnackBar("Unable to add new purchase");

            });*/
          },
          tooltip: 'New Purchase',
          child: Icon(Icons.add),
        );
      case 3:
        return FloatingActionButton(
          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) =>
                  NewStore(scaffoldKey)
              ),
            );*/
          },
          tooltip: 'New Store',
          child: Icon(Icons.add),
        );
      case 4:
        return FloatingActionButton(
          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) =>
                  NewPlatform(scaffoldKey)
              ),
            );*/
          },
          tooltip: 'New Platform',
          child: Icon(Icons.add),
        );
    }
  }

  Widget _getEntityStream({@required Stream<List<Entity>> entityStream, @required Function handleDelete}) {

    return StreamBuilder(
      stream: entityStream,
      builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<Entity> results = snapshot.data;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            Entity result = results[index];

            return result.getModifyCard(
                context,
                handleDelete: () {
                  showDialog<bool>(
                    context: context,
                    builder: (context) {
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
                  ).then( (bool option) {

                    if(option != null && option) {
                      handleDelete(result);
                    }

                  });
                }
            );
          },
        );
      },

    );

  }

  Widget getGamesStream() {

    return _getEntityStream(
        entityStream: _db.getAllGames(),
        handleDelete: (Game result) {
          _db.deleteGame(result.ID).then( (dynamic data) {

            _showSnackBar("Deleted " + result.getFormattedTitle());

          }, onError: (e) {

            _showSnackBar("Unable to delete " + result.getFormattedTitle());

          });
        },
    );

  }

  Widget getDLCsStream() {

    return _getEntityStream(
      entityStream: _db.getAllDLCs(),
      handleDelete: (DLC result) {
        _db.deleteDLC(result.ID).then( (dynamic data) {

          _showSnackBar("Deleted " + result.getFormattedTitle());

        }, onError: (e) {

          _showSnackBar("Unable to delete " + result.getFormattedTitle());

        });
      },
    );

  }

  Widget getPurchasesStream() {

    return _getEntityStream(
      entityStream: _db.getAllPurchases(),
      handleDelete: (Purchase result) {
        _db.deletePurchase(result.ID).then( (dynamic data) {

          _showSnackBar("Deleted " + result.getFormattedTitle());

        }, onError: (e) {

          _showSnackBar("Unable to delete " + result.getFormattedTitle());

        });
      },
    );

  }

  Widget getStoresStream() {

    return _getEntityStream(
      entityStream: _db.getAllStores(),
      handleDelete: (Store result) {
        _db.deleteStore(result.ID).then( (dynamic data) {

          _showSnackBar("Deleted " + result.getFormattedTitle());

        }, onError: (e) {

          _showSnackBar("Unable to delete " + result.getFormattedTitle());

        });
      },
    );

  }

  Widget getPlatformsStream() {

    return _getEntityStream(
      entityStream: _db.getAllPlatforms(),
      handleDelete: (Platform result) {
        _db.deletePlatform(result.ID).then( (dynamic data) {

          _showSnackBar("Deleted " + result.getFormattedTitle());

        }, onError: (e) {

          _showSnackBar("Unable to delete " + result.getFormattedTitle());

        });
      },
    );

  }

  Widget _getSelectedWidget() {
    switch (_selectedScreen) {
      case 0:
        return getGamesStream();
      case 1:
        return getDLCsStream();
      case 2:
        return getPurchasesStream();
      case 3:
        return getStoresStream();
      case 4:
        return getPlatformsStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(_barTitles[_selectedScreen]),
      ),
      body: Container(
        child: _getSelectedWidget(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedScreen,
        onTap: (index) {
          setState(() {
            _selectedScreen = index;
          });
        },
        items: _barItems,
      ),
      floatingActionButton: _getSelectedFAB(context),
    );
  }
}
