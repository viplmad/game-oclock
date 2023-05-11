import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart' show PrimaryModel;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/bloc/item_list/item_list.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';
import 'package:game_collection/ui/common/header_text.dart';
import 'package:game_collection/ui/common/item_view.dart';
import 'package:game_collection/ui/common/list_view.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';

import '../detail/detail_arguments.dart';
import '../search/search_arguments.dart';

abstract class ItemAppBar<T extends PrimaryModel,
        K extends Bloc<ItemListEvent, ItemListState>> extends StatelessWidget
    implements PreferredSizeWidget {
  const ItemAppBar({
    Key? key,
    required this.themeColor,
    required this.gridAllowed,
    required this.searchRouteName,
    required this.detailRouteName,
    this.calendarRouteName = '',
  }) : super(key: key);

  final Color themeColor;
  final bool gridAllowed;
  final String searchRouteName;
  final String detailRouteName;
  final String calendarRouteName;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(typesName(context)),
      surfaceTintColor: themeColor,
      // Fixed elevation so background color doesn't change on scroll
      elevation: 1.0,
      scrolledUnderElevation: 1.0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: GameCollectionLocalisations.of(context).searchAllString,
          onPressed: searchRouteName.isNotEmpty
              ? () async {
                  Navigator.pushNamed<T>(
                    context,
                    searchRouteName,
                    arguments: const SearchArguments(
                      onTapReturn: false,
                    ),
                  ).then((T? added) {
                    if (added != null) {
                      final String typeString = typeName(context);
                      final String message =
                          GameCollectionLocalisations.of(context)
                              .addedString(typeString);
                      showSnackBar(
                        context,
                        message: message,
                        seconds: 2,
                        snackBarAction: backgroundSnackBarAction(
                          context,
                          label: GameCollectionLocalisations.of(context)
                              .openString,
                          onPressed: () async {
                            Navigator.pushNamed(
                              context,
                              detailRouteName,
                              arguments: DetailArguments<T>(
                                item: added,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  });
                }
              : null,
        ),
        calendarRouteName.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.date_range),
                tooltip: GameCollectionLocalisations.of(context).calendarView,
                onPressed: _onCalendarTap(context),
              )
            : const SizedBox(),
        gridAllowed
            ? IconButton(
                icon: const Icon(Icons.grid_on),
                tooltip:
                    GameCollectionLocalisations.of(context).changeStyleString,
                onPressed: () {
                  BlocProvider.of<K>(context).add(
                    UpdateStyle(),
                  );
                },
              )
            : const SizedBox(),
        _viewActionBuilder(
          context,
          views: views(context),
        ),
      ],
    );
  }

  Widget _viewActionBuilder(
    BuildContext context, {
    required List<String> views,
  }) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.view_carousel),
      tooltip: GameCollectionLocalisations.of(context).changeViewString,
      itemBuilder: (BuildContext context) {
        return views.map<PopupMenuItem<int>>((String view) {
          return PopupMenuItem<int>(
            value: views.indexOf(view),
            child: ListTile(
              title: Text(view),
            ),
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

  void Function() _onCalendarTap(BuildContext context) {
    return () async {
      Navigator.pushNamed(
        context,
        calendarRouteName,
      );
    };
  }

  String typeName(BuildContext context);
  String typesName(BuildContext context);
  List<String> views(BuildContext context);
}

abstract class ItemFAB<T extends PrimaryModel, N extends Object,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends StatelessWidget {
  const ItemFAB({
    Key? key,
    required this.themeColor,
  }) : super(key: key);

  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip:
          GameCollectionLocalisations.of(context).newString(typeName(context)),
      backgroundColor: themeColor,
      foregroundColor: Colors.white,
      onPressed: () {
        BlocProvider.of<S>(context).add(
          AddItem<N>(createItem()),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  N createItem();
  String typeName(BuildContext context);
}

abstract class ItemList<
        T extends PrimaryModel,
        K extends Bloc<ItemListEvent, ItemListState>,
        S extends Bloc<ItemListManagerEvent, ItemListManagerState>>
    extends StatelessWidget {
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
        if (state is ItemAdded<T>) {
          final String message = GameCollectionLocalisations.of(context)
              .addedString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
            snackBarAction: backgroundSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).openString,
              onPressed: () async {
                Navigator.pushNamed(
                  context,
                  detailRouteName,
                  arguments: DetailArguments<T>(
                    item: state.item,
                  ),
                );
              },
            ),
          );
        }
        if (state is ItemNotAdded) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToAddString(currentTypeString);
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
        if (state is ItemDeleted<T>) {
          final String message = GameCollectionLocalisations.of(context)
              .deletedString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
          );
        }
        if (state is ItemNotDeleted) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToDeleteString(currentTypeString);
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
        if (state is ItemListNotLoaded) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToLoadString(currentTypeString);
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
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<K>(context).add(ReloadItemList());
        },
        child: BlocBuilder<K, ItemListState>(
          builder: (BuildContext context, ItemListState state) {
            if (state is ItemListLoaded<T>) {
              return itemListBodyBuilder(
                items: state.items,
                viewIndex: state.viewIndex,
                viewArgs: state.viewArgs,
                onDelete: (T item) {
                  BlocProvider.of<S>(context).add(DeleteItem<T>(item));
                },
                style: state.style,
                scrollController: scrollController,
              );
            }
            if (state is ItemListError) {
              return Container();
            }

            return Column(
              children: <Widget>[
                const LinearProgressIndicator(),
                Container(
                  color: Colors.grey,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      HeaderSkeleton(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void Function() paginateListener(
    BuildContext context,
    ScrollController scrollController,
  ) {
    return () {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        BlocProvider.of<K>(context).add(UpdatePage());
      }
    };
  }

  String typeName(BuildContext context);

  ItemListBody<T, K> itemListBodyBuilder({
    required List<T> items,
    required int viewIndex,
    required Object? viewArgs,
    required void Function(T) onDelete,
    required ListStyle style,
    required ScrollController scrollController,
  });
}

abstract class ItemListBody<T extends PrimaryModel,
    K extends Bloc<ItemListEvent, ItemListState>> extends StatelessWidget {
  const ItemListBody({
    Key? key,
    required this.items,
    required this.viewIndex,
    required this.viewArgs,
    required this.onDelete,
    required this.style,
    required this.scrollController,
    required this.detailRouteName,
    required this.searchRouteName,
  }) : super(key: key);

  final List<T> items;
  final int viewIndex;
  final Object? viewArgs;
  final void Function(T) onDelete;
  final ListStyle style;
  final ScrollController scrollController;

  final String detailRouteName;
  final String searchRouteName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey,
          child: HeaderText(
            text: viewTitle(context),
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
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
        title: Text(
          GameCollectionLocalisations.of(context)
              .deleteDialogTitle(itemTitle(item)),
        ),
        subtitle:
            Text(GameCollectionLocalisations.of(context).deleteDialogSubtitle),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () async {
            Navigator.maybePop<bool>(context);
          },
        ),
        TextButton(
          onPressed: () async {
            Navigator.maybePop<bool>(context, true);
          },
          child:
              Text(GameCollectionLocalisations.of(context).deleteButtonLabel),
        )
      ],
    );
  }

  Widget _listBuilder(BuildContext context, ScrollController scrollController) {
    switch (style) {
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

  @nonVirtual
  void Function()? onTap(BuildContext context, T item) {
    return () async {
      Navigator.pushNamed(
        context,
        detailRouteName,
        arguments: DetailArguments<T>(
          item: item,
          onChange: () {
            BlocProvider.of<K>(context).add(ReloadItemList());
          },
        ),
      );
    };
  }

  String itemTitle(T item);
  String viewTitle(BuildContext context);

  Widget cardBuilder(BuildContext context, T item);
  external Widget gridBuilder(BuildContext context, T item);
}

class ItemCardView<T extends PrimaryModel> extends StatelessWidget {
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
    return ItemListBuilder(
      itemCount: items.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        final T item = items.elementAt(index);

        return DismissibleItem(
          dismissibleKey: item.id,
          itemWidget: itemBuilder(context, item),
          onDismissed: (DismissDirection direction) {
            onDismiss(item);
          },
          confirmDismiss: (DismissDirection direction) async {
            return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return confirmDelete(context, item);
              },
            ).then((bool? value) => value ?? false);
          },
          dismissIcon: Icons.delete,
        );
      },
    );
  }
}

class ItemGridView<T extends PrimaryModel> extends StatelessWidget {
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
