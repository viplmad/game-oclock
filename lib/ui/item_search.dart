import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item/item.dart';

import 'common/item_view.dart';


class ItemSearch<T extends ItemSearchBloc> extends StatefulWidget {
  const ItemSearch({Key key, @required this.searchType, @required this.itemBloc, @required this.onTapBehaviour, this.allowNewButton = false}) : super(key: key);

  final Type searchType;
  final ItemBloc itemBloc;
  final Function() Function(BuildContext, CollectionItem) onTapBehaviour;
  final bool allowNewButton;

  @override
  State<ItemSearch> createState() => _ItemSearchState<T>();
}
class _ItemSearchState<T extends ItemSearchBloc> extends State<ItemSearch> {
  final TextEditingController _textEditingController = TextEditingController();
  String get query => _textEditingController.text;
  set query(String value) {
    assert(query != null);
    _textEditingController.text = value;
  }

  ItemSearchBloc _itemSearchBloc;
  String get searchName => widget.searchType.toString();

  @override
  void initState() {
    super.initState();

    _itemSearchBloc = BlocProvider.of<T>(context);
  }

  List<Widget> buildActions() {

    return <Widget> [
      IconButton(
        icon: Icon(Icons.clear),
        tooltip: 'Clear',
        onPressed: () {
          _textEditingController.clear();
          _itemSearchBloc.add(
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

          widget.itemBloc.add(
            AddItem(Item(ID: 0, title: query)),
          );

        },
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: buildActions(),
        title: TextField(
          controller: _textEditingController,
          keyboardType: TextInputType.text,
          onChanged: (String newQuery) {
            //Not sure of this fix to update button text
            setState(() {});
            _itemSearchBloc.add(
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
      body: BlocListener<ItemBloc, ItemState>(
        bloc: widget.itemBloc,
        listener: (BuildContext context, ItemState state) {
          if(state is ItemAdded) {
            Navigator.maybePop(context, state.item);
          }
        },
        child: Column(
          children: <Widget>[
            widget.allowNewButton?
              Container(
                child: newButton(),
                color: Colors.grey,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              ) : Container(),
            BlocBuilder<ItemSearchBloc, ItemSearchState>(
              bloc: _itemSearchBloc,
              builder: (BuildContext context, ItemSearchState state) {

                if(state is ItemSearchEmpty) {

                  return listItems(state.suggestions);

                }
                if(state is ItemSearchSuccess) {

                  return listItems(state.results);

                }
                if(state is ItemSearchError) {

                  return Center(
                    child: Text("Error during search" + "\n" + state.error),
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

  Widget listItems(List<CollectionItem> results) {

    if(results.isEmpty) {
      return Center(
        child: Text("No results found", textAlign: TextAlign.center,),
      );
    }

    return Expanded(
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            CollectionItem result = results[index];

            return ItemListCard(
              item: result,
              onTap: widget.onTapBehaviour(context, result),
            );

          },
        ),
      ),
    );

  }

  @override
  void dispose() {

    _itemSearchBloc.close();
    super.dispose();

  }

}

class ItemLocalSearch extends ItemSearch
{

}
class ItemLocalSearchState extends _ItemSearchState
{
  @override
  ItemSearchBloc getSearchBloc() {
    BlocProvider.of<ItemLocalSearchBloc>(context);
  }
}