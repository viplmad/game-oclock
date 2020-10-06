import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import '../common/item_view.dart';
import '../common/show_snackbar.dart';


abstract class ItemSearch<T extends CollectionItem, K extends ItemSearchBloc<T>, S extends ItemListManagerBloc<T>> extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<K>(
            create: (BuildContext context) {
              return searchBlocBuilder()..add(SearchTextChanged());
            }
        ),

        BlocProvider<S>(
            create: (BuildContext context) {
              return managerBlocBuilder();
            }
        ),

      ],
      child: _ItemSearchBody<T, K, S>(
        onTap: onTap,
        allowNewButton: true,
      ),
    );

  }

  void Function() onTap(BuildContext context, T item) {

    return () {
      Navigator.maybePop<T>(context, item);
    };

  }

  external K searchBlocBuilder();
  external S managerBlocBuilder();

}

abstract class ItemLocalSearch<T extends CollectionItem, S extends ItemListManagerBloc<T>> extends StatelessWidget {
  ItemLocalSearch({Key key, @required this.items}) : super(key: key);

  final List<T> items;

  String detailRouteName;

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemLocalSearchBloc<T>>(
          create: (BuildContext context) {
            return ItemLocalSearchBloc<T>(
              items: items,
            )..add(SearchTextChanged());
          },
        ),

        BlocProvider<S>(
            create: (BuildContext context) {
              return managerBlocBuilder();
            }
        ),

      ],
      child: _ItemSearchBody<T, ItemLocalSearchBloc<T>, S>(
        onTap: onTap,
        allowNewButton: false,
      ),
    );

  }

  void Function() onTap(BuildContext context, T item) {

    return () {
      Navigator.pushNamed(
        context,
        detailRouteName,
        arguments: item,
      );
    };

  }

  external S managerBlocBuilder();

}

class _ItemSearchBody<T extends CollectionItem, K extends ItemSearchBloc<T>, S extends ItemListManagerBloc<T>> extends StatefulWidget {
  const _ItemSearchBody({Key key, @required this.onTap, this.allowNewButton = false}) : super(key: key);

  final void Function() Function(BuildContext, T) onTap;
  final bool allowNewButton;

  @override
  State<_ItemSearchBody<T, K, S>> createState() => _ItemSearchBodyState<T, K, S>();
}
class _ItemSearchBodyState<T extends CollectionItem, K extends ItemSearchBloc<T>, S extends ItemListManagerBloc<T>> extends State<_ItemSearchBody<T, K, S>> {
  final TextEditingController _textEditingController = TextEditingController();
  String get query => _textEditingController.text;
  set query(String value) {
    assert(query != null);
    _textEditingController.text = value;
  }

  String get searchName => T.toString();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: buildActions(),
        title: TextField(
          controller: _textEditingController,
          keyboardType: TextInputType.text,
          autofocus: true,
          onChanged: (String newQuery) {
            //Not sure of this fix to update button text
            setState(() {});
            BlocProvider.of<K>(context).add(
              SearchTextChanged(query),
            );
          },
          maxLines: 1,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            prefixIcon: Icon(Icons.search),
            hintText: 'Search ' + searchName + 's',
          ),
        ),
      ),
      body: BlocListener<S, ItemListManagerState>(
        listener: (BuildContext context, ItemListManagerState state) {
          if(state is ItemAdded<T>) {

            Navigator.maybePop<T>(context, state.item);

          }
          if(state is ItemNotAdded) {
            showSnackBar(
              scaffoldState: Scaffold.of(context),
              message: "Unable to add",
              seconds: 2,
              snackBarAction: dialogSnackBarAction(
                context,
                label: "More",
                title: "Unable to add",
                content: state.error,
              ),
            );
          }
        },
        child: Column(
          children: <Widget>[
            widget.allowNewButton?
              Container(
                child: newButton(),
                color: Colors.grey,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              )
              :
              Container(),
            BlocBuilder<K, ItemSearchState>(
              builder: (BuildContext context, ItemSearchState state) {

                if(state is ItemSearchEmpty<T>) {

                  return listItems(state.suggestions, "");

                }
                if(state is ItemSearchSuccess<T>) {

                  return listItems(state.results, "No results found");

                }
                if(state is ItemSearchError) {

                  return Center(
                    child: Text(state.error),
                  );

                }

                return LinearProgressIndicator();

              },
            ),
          ],
        ),
      ),
    );

  }

  List<Widget> buildActions() {

    return <Widget> [
      IconButton(
        icon: Icon(Icons.clear),
        tooltip: 'Clear',
        onPressed: () {
          _textEditingController.clear();
          BlocProvider.of<K>(context).add(
            SearchTextChanged(query),
          );
        },
      ),
    ];

  }

  Widget newButton() {

    return SizedBox(
      width: double.maxFinite,
      child: FlatButton(
        child: Text("+ New " + searchName + " titled '" + query + "'"),
        color: Colors.white,
        onPressed: () {

          BlocProvider.of<S>(context).add(AddItem(query));

        },
      ),
    );

  }

  Widget listItems(List<T> results, String emptyMessage) {

    if(results.isEmpty) {
      return Center(
        child: Text(emptyMessage),
      );
    }

    return Expanded(
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            T result = results[index];

            return Padding(
              padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
              child: ItemCard(
                title: result.getTitle(),
                subtitle: result.getSubtitle(),
                imageURL: result.getImageURL(),
                onTap: widget.onTap(context, result),
              ),
            );

          },
        ),
      ),
    );

  }

}