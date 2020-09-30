import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item/item.dart';

import 'common/item_view.dart';


class ItemSearch<T extends CollectionItem> extends StatefulWidget {
  const ItemSearch({Key key, @required this.itemSearchBloc, @required this.itemBloc, @required this.onTapBehaviour, this.allowNewButton = false}) : super(key: key);

  final ItemSearchBloc<T> itemSearchBloc;
  final ItemBloc<T> itemBloc;
  final void Function() Function(BuildContext, T) onTapBehaviour;
  final bool allowNewButton;

  @override
  State<ItemSearch> createState() => _ItemSearchState<T>();
}
class _ItemSearchState<T extends CollectionItem> extends State<ItemSearch<T>> {
  final TextEditingController _textEditingController = TextEditingController();
  String get query => _textEditingController.text;
  set query(String value) {
    assert(query != null);
    _textEditingController.text = value;
  }

  String get searchName => T.toString(); // TODO: Localisations

  List<Widget> buildActions() {

    return <Widget> [
      IconButton(
        icon: Icon(Icons.clear),
        tooltip: 'Clear',
        onPressed: () {
          _textEditingController.clear();
          widget.itemSearchBloc.add(
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
            AddItem(query),
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
            widget.itemSearchBloc.add(
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
      body: BlocListener<ItemBloc<T>, ItemState>(
        bloc: widget.itemBloc,
        listener: (BuildContext context, ItemState state) {
          if(state is ItemAdded<T>) {
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
            BlocBuilder<ItemSearchBloc<T>, ItemSearchState>(
              bloc: widget.itemSearchBloc,
              builder: (BuildContext context, ItemSearchState state) {

                if(state is ItemSearchEmpty<T>) {

                  return listItems(state.suggestions);

                }
                if(state is ItemSearchSuccess<T>) {

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

  Widget listItems(List<T> results) {

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
            T result = results[index];

            var onTap = widget.onTapBehaviour(context, result);

            return ItemListCard(
              item: result,
              onTap: onTap,
            );

          },
        ),
      ),
    );

  }

  @override
  void dispose() {

    widget.itemSearchBloc.close();
    super.dispose();

  }

}