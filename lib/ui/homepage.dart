import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/entity.dart';
import 'package:game_collection/model/bar_item.dart';
import 'package:game_collection/model/app_tab.dart';


import 'package:game_collection/bloc/entity_list/entity_list.dart';
import 'package:game_collection/bloc/tab/tab.dart';

import 'package:game_collection/ui/helpers/loading_icon.dart';
import 'package:game_collection/ui/helpers/show_snackbar.dart';
import 'package:game_collection/ui/helpers/entity_view.dart';

import 'bar_items.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TabBloc, AppTab> (
      builder: (BuildContext context, AppTab state) {
        BarItem barItem = barItems.elementAt(AppTab.values.indexOf(state));

        EntityListBloc selectedBloc;
        switch(state) {
          case AppTab.game:
            selectedBloc = BlocProvider.of<GameListBloc>(context);
            break;
          case AppTab.dlc:
            selectedBloc = BlocProvider.of<DLCListBloc>(context);
            break;
          case AppTab.purchase:
          // TODO: Handle this case.
            selectedBloc = BlocProvider.of<GameListBloc>(context);
            break;
          case AppTab.store:
          // TODO: Handle this case.
            selectedBloc = BlocProvider.of<GameListBloc>(context);
            break;
          case AppTab.platform:
          // TODO: Handle this case.
            selectedBloc = BlocProvider.of<GameListBloc>(context);
            break;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(barItem.title + 's'),
            backgroundColor: barItem.color,
          ),
          body: BodySelector(
            activeTab: state,
            bloc: selectedBloc,
          ),
          bottomNavigationBar: TabSelector(
            activeTab: state,
            onTap: (tab) {
              BlocProvider.of<TabBloc>(context).add(UpdateTab(tab));
            },
          ),
          floatingActionButton: FABSelector(
            activeTab: state,
            onTap: () {
              selectedBloc.add(AddEntity(null));
            },
          ),
        );
      },
    );

  }

}

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTap;

  TabSelector({Key key, @required this.activeTab, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      type: BottomNavigationBarType.shifting,
      onTap: (index) {
        onTap(AppTab.values.elementAt(index));
      },
      items: barItems.map<BottomNavigationBarItem>( (barItem) {
        return BottomNavigationBarItem(
          title: Text(barItem.title + 's'),
          icon: Icon(barItem.icon),
          backgroundColor: barItem.color,
        );
      }).toList(growable: false),
    );

  }

}

class FABSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function() onTap;

  FABSelector({Key key, @required this.activeTab, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BarItem barItem = barItems.elementAt(AppTab.values.indexOf(activeTab));

    return FloatingActionButton(
      onPressed: () {
        onTap();
      },
      tooltip: 'New ' + barItem.title,
      child: Icon(Icons.add),
      backgroundColor: barItem.color,
    );

  }
}

class BodySelector extends StatelessWidget {

  final AppTab activeTab;
  final EntityListBloc bloc;

  const BodySelector({Key key, @required this.activeTab, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<EntityListBloc, EntityListState>(
      bloc: bloc,
      builder: (BuildContext context, EntityListState state) {

        if(state is EntityListLoaded) {
          return EntityList(
            entities: state.entities,
            bloc: bloc,
          );
        }
        //else EntityListLoading
        return Center(
          child: LoadingIcon(),
        );

      },
    );

  }

}

class EntityList extends StatelessWidget {
  final List<Entity> entities;
  final EntityListBloc bloc;

  EntityList({Key key, @required this.entities, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocListener<EntityListBloc, EntityListState>(
      bloc: bloc,
      listener: (BuildContext context, EntityListState state) {
        if(state is EntityListNotLoaded)
        showSnackBar(
          scaffoldState: Scaffold.of(context),
          message: state.error,
        );
      },
      child: Scrollbar(
        child: ListView.builder(
          itemCount: entities.length,
          itemBuilder: (BuildContext context, int index) {
            Entity result = entities[index];

            return DismissibleEntity(
              entity: result,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text("Hero"),
                        ),
                        body: Center(),
                      );
                    },
                  ),
                );
              },
              onDismissed: (DismissDirection direction) {
                bloc.add(DeleteEntity(result));
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
      ),
    );

  }

  Widget confirmDelete(BuildContext context, Entity entity) {
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