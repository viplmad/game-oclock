import 'package:flutter/material.dart';

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
            _db.insertDLC().then( (dynamic data) {

              _showSnackBar("Added new DLC");

            }, onError: (e) {

              _showSnackBar("Unable to add new DLC");

            });
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) =>
                  NewDLC(scaffoldKey)
              ),
            );*/
          },
          tooltip: 'New DLC',
          child: Icon(Icons.add),
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            _db.insertPurchase().then( (dynamic data) {

              _showSnackBar("Added new purchase");

            }, onError: (e) {

              _showSnackBar("Unable to add new purchase");

            });
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) =>
                  NewPurchase(scaffoldKey)
              ),
            );*/
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

  Widget getGamesStream() {
    return StreamBuilder(
      stream: _db.getAllGames(),
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<Game> results = snapshot.data;

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            Game result = results[index];

            return result.getModifyCard(context);
          },
        );
      },

    );
  }

  Widget getDLCsStream() {
    return StreamBuilder(
      stream: _db.getAllDLCs(),
      builder: (BuildContext context, AsyncSnapshot<List<DLC>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<DLC> results = snapshot.data;

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            DLC result = results[index];

            return result.getModifyCard(context);
          },
        );
      },

    );
  }

  Widget getPurchasesStream() {
    return StreamBuilder(
      stream: _db.getAllPurchases(),
      builder: (BuildContext context, AsyncSnapshot<List<Purchase>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<Purchase> results = snapshot.data;

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            Purchase result = results[index];

            return result.getModifyCard(context);
          },
        );
      },

    );
  }

  Widget getStoresStream() {
    return StreamBuilder(
      stream: _db.getAllStores(),
      builder: (BuildContext context, AsyncSnapshot<List<Store>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<Store> results = snapshot.data;

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            Store result = results[index];

            return result.getModifyCard(context);
          },
        );
      },

    );
  }

  Widget getPlatformsStream() {
    return StreamBuilder(
      stream: _db.getAllPlatforms(),
      builder: (BuildContext context, AsyncSnapshot<List<Platform>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        List<Platform> results = snapshot.data;

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            Platform result = results[index];

            return result.getModifyCard(context);
          },
        );
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
