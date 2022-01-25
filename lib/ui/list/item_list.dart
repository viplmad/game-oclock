import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show Item;
import 'package:backend/model/list_style.dart';

import 'package:backend/bloc/item_list/item_list.dart';
import 'package:backend/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/loading_icon.dart';
import '../common/show_snackbar.dart';
import '../detail/detail.dart';
import '../statistics/statistics.dart';


abstract class ItemAppBar<T extends Item, K extends Bloc<ItemListEvent, ItemListState>> extends StatelessWidget with PreferredSizeWidget {
  const ItemAppBar({
    Key? key,
    required this.themeColor,
    this.gridAllowed = true,
  }) : super(key: key);

  final Color themeColor;
  final bool gridAllowed;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(typesName(context)),
      backgroundColor: themeColor,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.sort_by_alpha),
          tooltip: GameCollectionLocalisations.of(context).changeOrderString,
          onPressed: () {
            BlocProvider.of<K>(context).add(UpdateSortOrder());
          },
        ),
        gridAllowed? IconButton(
          icon: const Icon(Icons.grid_on),
          tooltip: GameCollectionLocalisations.of(context).changeStyleString,
          onPressed: () {
            BlocProvider.of<K>(context).add(UpdateStyle());
          },
        ) : Container(),
        _viewActionBuilder(
          context,
          views: views(context),
        ),
      ],
    );

  }

  Widget _viewActionBuilder(BuildContext context, {required List<String> views}) {

    return PopupMenuButton<int>(
      icon: const Icon(Icons.view_carousel),
      tooltip: GameCollectionLocalisations.of(context).changeViewString,
      itemBuilder: (BuildContext context) {
        return views.map<PopupMenuItem<int>>( (String view) {
          return PopupMenuItem<int>(
            child: ListTile(
              title: Text(view),
            ),
            value: views.indexOf(view),
          );
        }).toList(growable: false);
      },
      onSelected: onSelected(context, views),
    );

  }

  void Function(int) onSelected(BuildContext context, List<String> views) {

    return (int selectedViewIndex) {
      BlocProvider.of<K>(context).add(UpdateView(selectedViewIndex));
    };

  }

  String typesName(BuildContext context);
  List<String> views(BuildContext context);
}

abstract class ItemFAB<T extends Item, S extends Bloc<ItemListManagerEvent, ItemListManagerState>> extends StatelessWidget {
  const ItemFAB({
    Key? key,
    required this.themeColor,
  }) : super(key: key);

  final Color themeColor;

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      child: const Icon(Icons.add),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      tooltip: GameCollectionLocalisations.of(context).newString(typeName(context)),
      backgroundColor: themeColor,
      onPressed: () {
        BlocProvider.of<S>(context).add(
          AddItem<T>(createItem()),
        );
      },
    );

  }

  T createItem();
  String typeName(BuildContext context);
}

abstract class ItemList<T extends Item, K extends Bloc<ItemListEvent, ItemListState>, S extends Bloc<ItemListManagerEvent, ItemListManagerState>> extends StatelessWidget {
  const ItemList({
    Key? key,
    this.detailRouteName = '',
  }) : super(key: key);

  final String detailRouteName;

  @override
  Widget build(BuildContext context) {
    final String currentTypeString = typeName(context);

    final ScrollController scrollController = ScrollController();
    scrollController.addListener(paginateListener(context, scrollController));

    return BlocListener<S, ItemListManagerState>(
      listener: (BuildContext context, ItemListManagerState state) {
        if(state is ItemAdded<T>) {
          final String message = GameCollectionLocalisations.of(context).addedString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
            snackBarAction: backgroundSnackBarAction(
              label: GameCollectionLocalisations.of(context).openString,
              onPressed: () {

                Navigator.pushNamed(
                  context,
                  detailRouteName,
                  arguments: DetailArguments<T>(
                    item: state.item,
                  )
                );

              },
            ),
          );
        }
        if(state is ItemNotAdded) {
          final String message = GameCollectionLocalisations.of(context).unableToAddString(currentTypeString);
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
        if(state is ItemDeleted<T>) {
          final String message = GameCollectionLocalisations.of(context).deletedString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
          );
        }
        if(state is ItemNotDeleted) {
          final String message = GameCollectionLocalisations.of(context).unableToDeleteString(currentTypeString);
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
      child: BlocBuilder<K, ItemListState>(
        builder: (BuildContext context, ItemListState state) {

          if(state is ItemListLoaded<T>) {

            return itemListBodyBuilder(
              items: state.items,
              viewIndex: state.viewIndex,
              viewYear: state.year,
              onDelete: (T item) {
                BlocProvider.of<S>(context).add(DeleteItem<T>(item));
              },
              style: state.style,
              scrollController: scrollController,
            );

          }
          if(state is ItemListNotLoaded) {

            return Center(
              child: Text(state.error),
            );

          }

          return const LoadingIcon();

        },
      ),
    );

  }

  void Function() paginateListener(BuildContext context, ScrollController scrollController) {

    return () {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        BlocProvider.of<K>(context).add(UpdatePage());
      }
    };

  }

  String typeName(BuildContext context);

  ItemListBody<T, K> itemListBodyBuilder({required List<T> items, required int viewIndex, required int viewYear, required void Function(T) onDelete, required ListStyle style, required ScrollController scrollController});
}

abstract class ItemListBody<T extends Item, K extends Bloc<ItemListEvent, ItemListState>> extends StatelessWidget {
  const ItemListBody({
    Key? key,
    required this.items,
    required this.viewIndex,
    required this.viewYear,
    required this.onDelete,
    required this.style,
    required this.scrollController,
    this.detailRouteName = '',
    this.localSearchRouteName = '',
    this.statisticsRouteName = '',
    this.calendarRouteName = '',
  }) : super(key: key);

  final List<T> items;
  final int viewIndex;
  final int viewYear;
  final void Function(T) onDelete;
  final ListStyle style;
  final ScrollController scrollController;

  final String detailRouteName;
  final String localSearchRouteName;
  final String statisticsRouteName;
  final String calendarRouteName;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            title: Text(viewTitle(context)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: GameCollectionLocalisations.of(context).searchInViewString,
                  onPressed: items.isNotEmpty? _onSearchTap(context) : null,
                ),
                statisticsRouteName.isNotEmpty?
                  IconButton(
                    icon: const Icon(Icons.insert_chart),
                    tooltip: GameCollectionLocalisations.of(context).statsInViewString,
                    onPressed: items.isNotEmpty? onStatisticsTap(context) : null,
                  ) : Container(),
                calendarRouteName.isNotEmpty?
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    tooltip: GameCollectionLocalisations.of(context).calendarView,
                    onPressed: _onCalendarTap(context),
                  ) : Container(),
              ],
            ),
          ),
          color: Colors.grey,
        ),
        Expanded(
          child: Scrollbar(
            child: _listBuilder(context, scrollController),
          ),
        ),
      ],
    );

  }

  Widget _confirmDelete(BuildContext context, T item) {

    return AlertDialog(
      title: Text(GameCollectionLocalisations.of(context).deleteString),
      content: ListTile(
        title: Text(GameCollectionLocalisations.of(context).deleteDialogTitle(itemTitle(item))),
        subtitle: Text(GameCollectionLocalisations.of(context).deleteDialogSubtitle),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<bool>(context);
          },
        ),
        TextButton(
          child: Text(GameCollectionLocalisations.of(context).deleteButtonLabel),
          onPressed: () {
            Navigator.maybePop<bool>(context, true);
          },
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
        )
      ],
    );

  }

  Widget _listBuilder(BuildContext context, ScrollController scrollController) {

    switch(style) {
      case ListStyle.card:
        return ItemCardView<T>(
          items: items,
          itemBuilder: cardBuilder,
          onDismiss: onDelete,
          confirmDelete: _confirmDelete,
          scrollController: scrollController,
        );
      case ListStyle.grid:
        return ItemGridView<T>(
          items: items,
          itemBuilder: gridBuilder,
          scrollController: scrollController,
        );
    }

  }

  void Function()? onTap(BuildContext context, T item) {

    return () {
      Navigator.pushNamed(
        context,
        detailRouteName,
        arguments: DetailArguments<T>(
          item: item,
          onUpdate: (T? updatedItem) {

            if(updatedItem != null) {

              BlocProvider.of<K>(context).add(UpdateListItem<T>(updatedItem));

            }

          },
        ),
      );
    };

  }

  void Function() _onSearchTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        localSearchRouteName,
        arguments: items,
      );
    };

  }

  void Function() onStatisticsTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        statisticsRouteName,
        arguments: StatisticsArguments<T>(
          items: items,
          viewTitle: viewTitle(context),
        ),
      );
    };

  }

  void Function() _onCalendarTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        calendarRouteName,
      );
    };

  }

  String itemTitle(T item);
  String viewTitle(BuildContext context);

  Widget cardBuilder(BuildContext context, T item);
  external Widget gridBuilder(BuildContext context, T item);
}

class ItemCardView<T extends Item> extends StatelessWidget {
  const ItemCardView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.onDismiss,
    required this.confirmDelete,
    required this.scrollController,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T item) onDismiss;
  final Widget Function(BuildContext, T) confirmDelete;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        final T item = items.elementAt(index);

        return DismissibleItem(
          dismissibleKey: item.uniqueId,
          itemWidget: itemBuilder(context, item),
          onDismissed: (DismissDirection direction) {
            onDismiss(item);
          },
          confirmDismiss: (DismissDirection direction) {

            return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return confirmDelete(context, item);
              },
            ).then((bool? value) => value?? false);

          },
          dismissIcon: Icons.delete,
        );

      },
    );

  }
}

class ItemGridView<T extends Item> extends StatelessWidget {
  const ItemGridView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.scrollController,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / 200).ceil(),
      ),
      itemBuilder: (BuildContext context, int index) {
        final T item = items[index];

        return itemBuilder(context, item);

      },
    );

  }
}