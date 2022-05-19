import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show Item;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_search/item_search.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/list_view.dart';
import '../common/show_snackbar.dart';
import '../detail/detail_arguments.dart';

abstract class ItemSearch<
        T extends Item,
        K extends Bloc<ItemSearchEvent, ItemSearchState>,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends StatelessWidget {
  const ItemSearch({
    Key? key,
    required this.onTapReturn,
    required this.viewIndex,
    this.detailRouteName = '',
  }) : super(key: key);

  final bool onTapReturn;
  final int? viewIndex;
  final String detailRouteName;

  @override
  Widget build(BuildContext context) {
    final GameCollectionRepository collectionRepository =
        RepositoryProvider.of<GameCollectionRepository>(context);

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<K>(
          create: (BuildContext context) {
            return searchBlocBuilder(collectionRepository)
              ..add(const SearchTextChanged());
          },
        ),
        BlocProvider<S>(
          create: (BuildContext context) {
            return managerBlocBuilder(collectionRepository);
          },
        ),
      ],
      child: itemSearchBodyBuilder(
        onTap: _onTap,
        allowNewButton: true,
      ),
    );
  }

  void Function()? _onTap(BuildContext context, T item) {
    return onTapReturn
        ? () {
            Navigator.maybePop<T>(context, item);
          }
        : detailRouteName.isNotEmpty
            ? () {
                Navigator.pushNamed(
                  context,
                  detailRouteName,
                  arguments: DetailArguments<T>(
                    item: item,
                  ),
                );
              }
            : null;
  }

  K searchBlocBuilder(GameCollectionRepository collectionRepository);
  S managerBlocBuilder(GameCollectionRepository collectionRepository);

  ItemSearchBody<T, K, S> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, T) onTap,
    required bool allowNewButton,
  });
}

abstract class ItemLocalSearch<T extends Item,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends StatelessWidget {
  const ItemLocalSearch({
    Key? key,
    required this.items,
    this.detailRouteName = '',
  }) : super(key: key);

  final List<T> items;
  final String detailRouteName;

  @override
  Widget build(BuildContext context) {
    final GameCollectionRepository collectionRepository =
        RepositoryProvider.of<GameCollectionRepository>(context);

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<ItemLocalSearchBloc<T>>(
          create: (BuildContext context) {
            return ItemLocalSearchBloc<T>(
              items: items,
            )..add(const SearchTextChanged());
          },
        ),
        BlocProvider<S>(
          create: (BuildContext context) {
            return managerBlocBuilder(collectionRepository);
          },
        ),
      ],
      child: itemSearchBodyBuilder(
        onTap: _onTap,
        allowNewButton: false,
      ),
    );
  }

  void Function()? _onTap(BuildContext context, T item) {
    return detailRouteName.isNotEmpty
        ? () {
            Navigator.pushNamed(
              context,
              detailRouteName,
              arguments: DetailArguments<T>(
                item: item,
              ),
            );
          }
        : null;
  }

  S managerBlocBuilder(GameCollectionRepository collectionRepository);

  ItemSearchBody<T, ItemLocalSearchBloc<T>, S> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, T) onTap,
    required bool allowNewButton,
  });
}

abstract class ItemSearchBody<
        T extends Item,
        K extends Bloc<ItemSearchEvent, ItemSearchState>,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends StatefulWidget {
  const ItemSearchBody({
    Key? key,
    required this.onTap,
    this.allowNewButton = false,
  }) : super(key: key);

  final void Function()? Function(BuildContext, T) onTap;
  final bool allowNewButton;

  String typeName(BuildContext context);
  String typesName(BuildContext context);

  T createItem(String query);
  Widget cardBuilder(BuildContext context, T item);

  @override
  State<ItemSearchBody<T, K, S>> createState() =>
      _ItemSearchBodyState<T, K, S>();
}

class _ItemSearchBodyState<
        T extends Item,
        K extends Bloc<ItemSearchEvent, ItemSearchState>,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends State<ItemSearchBody<T, K, S>> {
  final TextEditingController _textEditingController = TextEditingController();
  String get query => _textEditingController.text;
  set query(String value) {
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
            border: const UnderlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            hintText: GameCollectionLocalisations.of(context)
                .searchString(widget.typesName(context)),
          ),
        ),
      ),
      body: BlocListener<S, ItemListManagerState>(
        listener: (BuildContext context, ItemListManagerState state) {
          if (state is ItemAdded<T>) {
            Navigator.maybePop<T>(context, state.item);
          }
          if (state is ItemNotAdded) {
            final String message = GameCollectionLocalisations.of(context)
                .unableToAddString(widget.typeName(context));
            showSnackBar(
              context,
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
            widget.allowNewButton
                ? Container(
                    color: Colors.grey,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: _newButton(),
                  )
                : const SizedBox(),
            BlocBuilder<K, ItemSearchState>(
              builder: (BuildContext context, ItemSearchState state) {
                if (state is ItemSearchEmpty<T>) {
                  return listItems(
                    state.suggestions,
                    GameCollectionLocalisations.of(context).noSuggestionsString,
                  );
                }
                if (state is ItemSearchSuccess<T>) {
                  return listItems(
                    state.results,
                    GameCollectionLocalisations.of(context).noResultsString,
                  );
                }
                if (state is ItemSearchError) {
                  return Center(
                    child: Text(state.error),
                  );
                }

                return const LinearProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
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
      child: TextButton(
        onPressed: () {
          BlocProvider.of<S>(context).add(
            AddItem<T>(widget.createItem(query)),
          );
        },
        style: TextButton.styleFrom(
          primary: Theme.of(context).brightness == Brightness.light
              ? Colors.black87
              : Colors.white,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black54,
        ),
        child: Text(
          GameCollectionLocalisations.of(context)
              .newWithTitleString(widget.typeName(context), query),
        ),
      ),
    );
  }

  Widget listItems(List<T> results, String emptyMessage) {
    if (results.isEmpty) {
      return Center(
        child: Text(emptyMessage),
      );
    }

    return Expanded(
      child: Scrollbar(
        child: ItemListBuilder(
          padding: const EdgeInsets.all(8.0),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            final T result = results[index];

            return widget.cardBuilder(context, result);
          },
        ),
      ),
    );
  }
}
