import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:logic/service/service.dart' show GameCollectionService;
import 'package:logic/bloc/item_search/item_search.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/ui/common/list_view.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';
import 'package:game_collection/ui/utils/theme_utils.dart';

import '../detail/detail_arguments.dart';

abstract class ItemSearch<
        T extends PrimaryModel,
        N extends Object,
        K extends Bloc<ItemSearchEvent, ItemSearchState>,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends StatelessWidget {
  const ItemSearch({
    Key? key,
    required this.onTapReturn,
    this.detailRouteName = '',
  }) : super(key: key);

  final bool onTapReturn;
  final String detailRouteName;

  @override
  Widget build(BuildContext context) {
    final GameCollectionService collectionService =
        RepositoryProvider.of<GameCollectionService>(context);

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<K>(
          create: (BuildContext context) {
            return searchBlocBuilder(collectionService)
              ..add(const SearchTextChanged());
          },
        ),
        BlocProvider<S>(
          create: (BuildContext context) {
            return managerBlocBuilder(collectionService);
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
        ? () async {
            Navigator.maybePop<T>(context, item);
          }
        : detailRouteName.isNotEmpty
            ? () async {
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

  K searchBlocBuilder(GameCollectionService collectionService);
  S managerBlocBuilder(GameCollectionService collectionService);

  ItemSearchBody<T, N, K, S> itemSearchBodyBuilder({
    required void Function()? Function(BuildContext, T) onTap,
    required bool allowNewButton,
  });
}

abstract class ItemSearchBody<
        T extends PrimaryModel,
        N extends Object,
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

  N createItem(String query);
  Widget cardBuilder(BuildContext context, T item);

  @override
  State<ItemSearchBody<T, N, K, S>> createState() =>
      _ItemSearchBodyState<T, N, K, S>();
}

class _ItemSearchBodyState<
        T extends PrimaryModel,
        N extends Object,
        K extends Bloc<ItemSearchEvent, ItemSearchState>,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends State<ItemSearchBody<T, N, K, S>> {
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
            // Not sure of this fix to update button text
            setState(() {});
            BlocProvider.of<K>(context).add(
              SearchTextChanged(query),
            );
          },
          maxLines: 1,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            hintText: AppLocalizations.of(context)!
                .searchString(widget.typesName(context)),
          ),
        ),
        // Fixed elevation so background color doesn't change on scroll
        elevation: 1.0,
        scrolledUnderElevation: 1.0,
      ),
      body: BlocListener<S, ItemListManagerState>(
        listener: (BuildContext context, ItemListManagerState state) async {
          if (state is ItemAdded<T>) {
            Navigator.maybePop<T>(context, state.item);
          }
          if (state is ItemNotAdded) {
            final String message = AppLocalizations.of(context)!
                .unableToAddString(widget.typeName(context));
            showSnackBar(
              context,
              message: message,
              seconds: 2,
              snackBarAction: dialogSnackBarAction(
                context,
                label: AppLocalizations.of(context)!.moreString,
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
                    '',
                  );
                }
                if (state is ItemSearchSuccess<T>) {
                  return listItems(
                    state.results,
                    AppLocalizations.of(context)!.noResultsString,
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
        tooltip: AppLocalizations.of(context)!.clearSearchString,
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
            AddItem<N>(widget.createItem(query)),
          );
        },
        style: TextButton.styleFrom(
          foregroundColor:
              ThemeUtils.isThemeDark(context) ? Colors.white : Colors.black87,
          backgroundColor:
              ThemeUtils.isThemeDark(context) ? Colors.black54 : Colors.white,
        ),
        child: Text(
          AppLocalizations.of(context)!
              .newWithTitleString(query, widget.typeName(context)),
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
