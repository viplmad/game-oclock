import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';

import 'common/loading_icon.dart';
import 'common/item_view.dart';


class ItemSearch extends StatefulWidget {
  const ItemSearch({Key key, @required this.searchTable}) : super(key: key);

  final String searchTable;

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

  ItemSearchBloc _itemSearchBloc;

  @override
  void initState() {
    super.initState();

    _itemSearchBloc = ItemSearchBloc(
      collectionRepository: CollectionRepository(),
      tableSearch: widget.searchTable,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            tooltip: 'Clear',
            onPressed: () {
              query = '';
            },
          ),
        ],
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
      body: BlocBuilder<ItemSearchBloc, ItemSearchState>(
        bloc: _itemSearchBloc,
        builder: (BuildContext context, ItemSearchState state) {

          if(state is ItemSearchEmpty) {
            return Center(
              child: Text("Try with more words"),
            );
          }
          if(state is ItemSearchError) {
            return Center(
              child: Text("Error during search\n" + state.error),
            );
          }
          if(state is ItemSearchSuccess) {
            return listResults(state.results);
          }
          return LoadingIcon();

        },
      ),
    );

  }

  Widget listResults(List<CollectionItem> results) {

    if(results.isEmpty) {
      return Center(
        child: Text("No results found"),
      );
    }

    return ListView.builder(
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
    );

  }

  @override
  void dispose() {

    _itemSearchBloc.close();

    super.dispose();

  }

}