import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart' show PrimaryModel;

import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_search/item_search.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/utils/theme_utils.dart';

import '../detail/detail_arguments.dart';
import '../theme/theme.dart' show AppTheme;

abstract class ItemSearch<
        T extends PrimaryModel,
        N extends Object,
        K extends Bloc<ItemSearchEvent, ItemSearchState>,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends StatelessWidget {
  const ItemSearch({
    super.key,
    required this.onTapReturn,
    this.detailRouteName = '',
  });

  final bool onTapReturn;
  final String detailRouteName;

  @override
  Widget build(BuildContext context) {
    final GameOClockService collectionService =
        RepositoryProvider.of<GameOClockService>(context);

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

  K searchBlocBuilder(GameOClockService collectionService);
  S managerBlocBuilder(GameOClockService collectionService);

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
    super.key,
    required this.onTap,
    this.allowNewButton = false,
  });

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
              SearchTextChanged(query.trim()),
            );
          },
          maxLines: 1,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            prefixIcon: const Icon(AppTheme.searchIcon),
            hintText: AppLocalizations.of(context)!
                .searchString(widget.typesName(context)),
          ),
        ),
        // Fixed elevation so background colour doesn't change on scroll
        elevation: 1.0,
        scrolledUnderElevation: 1.0,
      ),
      body: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<S, ItemListManagerState>(
            listener: (BuildContext context, ItemListManagerState state) async {
              if (state is ItemAdded<T>) {
                Navigator.maybePop<T>(context, state.item);
              }
              if (state is ItemNotAdded) {
                final String message = AppLocalizations.of(context)!
                    .unableToAddString(widget.typeName(context));
                showApiErrorSnackbar(
                  context,
                  name: message,
                  error: state.error,
                  errorDescription: state.errorDescription,
                );
              }
            },
          ),
          BlocListener<K, ItemSearchState>(
            listener: (BuildContext context, ItemSearchState state) async {
              if (state is ItemSearchError) {
                final String message =
                    AppLocalizations.of(context)!.unableToLoadSearchString;
                showApiErrorSnackbar(
                  context,
                  name: message,
                  error: state.error,
                  errorDescription: state.errorDescription,
                );
              }
            },
          ),
        ],
        child: Column(
          children: <Widget>[
            widget.allowNewButton
                ? Container(
                    color: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  return ItemError(
                    title:
                        AppLocalizations.of(context)!.somethingWentWrongString,
                    onRetryTap: () =>
                        BlocProvider.of<K>(context).add(ReloadItemSearch()),
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
        icon: const Icon(AppTheme.clearIcon),
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
          foregroundColor: AppTheme.defaultThemeTextColor(context),
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
    return Expanded(
      child: Scrollbar(
        child: ItemListBuilder(
          itemCount: results.length,
          emptyTitle: emptyMessage,
          itemBuilder: (BuildContext context, int index) {
            final T result = results[index];

            return widget.cardBuilder(context, result);
          },
        ),
      ),
    );
  }
}
