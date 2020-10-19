import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../detail/detail.dart';


abstract class ItemSearch<T extends CollectionItem, K extends ItemSearchBloc<T>, S extends ItemListManagerBloc<T>> extends StatelessWidget {
  const ItemSearch({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<K>(
          create: (BuildContext context) {
            return searchBlocBuilder()..add(SearchTextChanged());
          },
        ),

        BlocProvider<S>(
          create: (BuildContext context) {
            return managerBlocBuilder();
          },
        ),

      ],
      child: itemSearchBodyBuilder(
        onTap: _onTap,
        allowNewButton: true,
      ),
    );

  }

  void Function() _onTap(BuildContext context, T item) {

    return () {
      Navigator.maybePop<T>(context, item);
    };

  }

  K searchBlocBuilder();
  S managerBlocBuilder();

  ItemSearchBody<T, K, S> itemSearchBodyBuilder({@required void Function() Function(BuildContext, T) onTap, @required bool allowNewButton});
}

abstract class ItemLocalSearch<T extends CollectionItem, S extends ItemListManagerBloc<T>> extends StatelessWidget {
  const ItemLocalSearch({
    Key key,
    @required this.items,
  }) : super(key: key);

  final List<T> items;

  String get detailRouteName;

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
          },
        ),

      ],
      child: itemSearchBodyBuilder(
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
        arguments: DetailArguments(
          item: item,
        ),
      );
    };

  }

  S managerBlocBuilder();

  ItemSearchBody<T, ItemLocalSearchBloc<T>, S> itemSearchBodyBuilder({@required void Function() Function(BuildContext, T) onTap, @required bool allowNewButton});
}

abstract class ItemSearchBody<T extends CollectionItem, K extends ItemSearchBloc<T>, S extends ItemListManagerBloc<T>> extends StatefulWidget {
  const ItemSearchBody({
    Key key,
    @required this.onTap,
    this.allowNewButton = false,
  }) : super(key: key);

  final void Function() Function(BuildContext, T) onTap;
  final bool allowNewButton;

  String typeName(BuildContext context);
  String typesName(BuildContext context);

  Widget cardBuilder(BuildContext context, T item);

  @override
  State<ItemSearchBody<T, K, S>> createState() => _ItemSearchBodyState<T, K, S>();
}
class _ItemSearchBodyState<T extends CollectionItem, K extends ItemSearchBloc<T>, S extends ItemListManagerBloc<T>> extends State<ItemSearchBody<T, K, S>> {
  final TextEditingController _textEditingController = TextEditingController();
  String get query => _textEditingController.text;
  set query(String value) {
    assert(query != null);
    _textEditingController.text = value;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: _buildActions(),
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
            hintText: GameCollectionLocalisations.of(context).searchString(widget.typesName(context)),
          ),
        ),
      ),
      body: BlocListener<S, ItemListManagerState>(
        listener: (BuildContext context, ItemListManagerState state) {
          if(state is ItemAdded<T>) {

            Navigator.maybePop<T>(context, state.item);

          }
          if(state is ItemNotAdded) {
            String message = GameCollectionLocalisations.of(context).unableToAddString(widget.typeName(context));
            showSnackBar(
              scaffoldState: Scaffold.of(context),
              message: message,
              seconds: 2,
              snackBarAction: dialogSnackBarAction(
                context,
                label: GameCollectionLocalisations.of(context).moreString,
                title: message,
                content: state.error,
              ),
            );
          }
        },
        child: Column(
          children: <Widget>[
            widget.allowNewButton?
              Container(
                child: _newButton(),
                color: Colors.grey,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              )
              :
              Container(),
            BlocBuilder<K, ItemSearchState>(
              builder: (BuildContext context, ItemSearchState state) {

                if(state is ItemSearchEmpty<T>) {

                  return listItems(state.suggestions, GameCollectionLocalisations.of(context).noSuggestionsString);

                }
                if(state is ItemSearchSuccess<T>) {

                  return listItems(state.results, GameCollectionLocalisations.of(context).noResultsString);

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

  List<Widget> _buildActions() {

    return <Widget> [
      IconButton(
        icon: Icon(Icons.clear),
        tooltip: GameCollectionLocalisations.of(context).clearSearchString,
        onPressed: () {
          _textEditingController.clear();
          BlocProvider.of<K>(context).add(
            SearchTextChanged(query),
          );
        },
      ),
    ];

  }

  Widget _newButton() {

    return SizedBox(
      width: double.maxFinite,
      child: FlatButton(
        child: Text(GameCollectionLocalisations.of(context).newWithTitleString(widget.typeName(context), query)),
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
              child: widget.cardBuilder(context, result),
            );

          },
        ),
      ),
    );

  }
}