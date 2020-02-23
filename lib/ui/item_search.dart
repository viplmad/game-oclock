import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item/item.dart';

import 'common/loading_icon.dart';
import 'common/item_view.dart';


class ItemSearch extends StatefulWidget {
  const ItemSearch({Key key, @required this.searchTable, @required this.itemBloc}) : super(key: key);

  final String searchTable;
  final ItemBloc itemBloc;

  @override
  State<ItemSearch> createState() => _ItemSearchState();
}
class _ItemSearchState extends State<ItemSearch> {
  final TextEditingController _textEditingController = TextEditingController();
  String get query => _textEditingController.text;
  set query(String value) {
    assert(query != null);
    _textEditingController.text = value;
  }

  ItemOnlineSearchBloc _itemSearchBloc;

  @override
  void initState() {
    super.initState();

    _itemSearchBloc = ItemOnlineSearchBloc(
      collectionRepository: CollectionRepository(),
      tableSearch: widget.searchTable,
    )..add(SearchTextChanged("")); //put empty string first, so suggestions will be shown
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

    return OutlineButton(
      child: Text("New " + widget.searchTable + " titled '" + query + "'"),
      onPressed: () {

        widget.itemBloc.add(AddItem(Item(ID: 0, title: query)));

      },
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
            _itemSearchBloc.add(
              SearchTextChanged(query),
            );
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search ' + widget.searchTable + 's',
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
            Container(
              child: Center(),//newButton(),
              color: Colors.grey,
            ),
            BlocBuilder<ItemOnlineSearchBloc, ItemSearchState>(
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
                    child: Text("Error during search"),
                  );

                }

                return LoadingIcon();

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
        child: Text("No results found"),
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

            return ItemCard(
              item: result,
              onTap: () {
                Navigator.maybePop(context, result);
              },
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