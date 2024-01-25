import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart' show PrimaryModel;

import 'package:logic/model/model.dart' show ListStyle;
import 'package:logic/bloc/item_list/item_list.dart';
import 'package:logic/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/common/item_view.dart';
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';

import '../detail/detail_arguments.dart';
import '../search/search_arguments.dart';
import '../theme/theme.dart' show AppTheme;

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
    final List<String> computedViews = views(context);

    return AppBar(
      title: Text(typesName(context)),
      surfaceTintColor: themeColor,
      // Fixed elevation so background colour doesn't change on scroll
      elevation: 1.0,
      scrolledUnderElevation: 1.0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(AppTheme.searchIcon),
          tooltip: AppLocalizations.of(context)!.searchAllString,
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
                          AppLocalizations.of(context)!.addedString(typeString);
                      showSnackBar(
                        context,
                        message: message,
                        seconds: 2,
                        snackBarAction: backgroundSnackBarAction(
                          context,
                          label: AppLocalizations.of(context)!.openString,
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
                icon: const Icon(AppTheme.calendarIcon),
                tooltip: AppLocalizations.of(context)!.calendarView,
                onPressed: _onCalendarTap(context),
              )
            : const SizedBox(),
        gridAllowed
            ? IconButton(
                icon: const Icon(AppTheme.changeStyleIcon),
                tooltip: AppLocalizations.of(context)!.changeStyleString,
                onPressed: () {
                  BlocProvider.of<K>(context).add(
                    UpdateStyle(),
                  );
                },
              )
            : const SizedBox(),
        computedViews.isNotEmpty
            ? _viewActionBuilder(
                context,
                views: computedViews,
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _viewActionBuilder(
    BuildContext context, {
    required List<String> views,
  }) {
    return PopupMenuButton<int>(
      icon: const Icon(AppTheme.changeViewIcon),
      tooltip: AppLocalizations.of(context)!.changeViewString,
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
      tooltip: AppLocalizations.of(context)!.newString(typeName(context)),
      backgroundColor: themeColor,
      foregroundColor: Colors.white,
      onPressed: () {
        BlocProvider.of<S>(context).add(
          AddItem<N>(createItem()),
        );
      },
      child: const Icon(AppTheme.addIcon),
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
          final String message =
              AppLocalizations.of(context)!.addedString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
            snackBarAction: backgroundSnackBarAction(
              context,
              label: AppLocalizations.of(context)!.openString,
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
          final String message = AppLocalizations.of(context)!
              .unableToAddString(currentTypeString);
          showApiErrorSnackbar(
            context,
            name: message,
            error: state.error,
            errorDescription: state.errorDescription,
          );
        }
        if (state is ItemDeleted<T>) {
          final String message =
              AppLocalizations.of(context)!.deletedString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
          );
        }
        if (state is ItemNotDeleted) {
          final String message = AppLocalizations.of(context)!
              .unableToDeleteString(currentTypeString);
          showApiErrorSnackbar(
            context,
            name: message,
            error: state.error,
            errorDescription: state.errorDescription,
          );
        }
        if (state is ItemListNotLoaded) {
          final String message = AppLocalizations.of(context)!
              .unableToLoadString(currentTypeString);
          showApiErrorSnackbar(
            context,
            name: message,
            error: state.error,
            errorDescription: state.errorDescription,
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
                onDelete: (T item) {
                  BlocProvider.of<S>(context).add(DeleteItem<T>(item));
                },
                style: state.style,
                scrollController: scrollController,
              );
            }
            if (state is ItemListError) {
              return ItemError(
                title: AppLocalizations.of(context)!.somethingWentWrongString,
                onRetryTap: () =>
                    BlocProvider.of<K>(context).add(ReloadItemList()),
              );
            }

            return Column(
              children: <Widget>[
                const LinearProgressIndicator(),
                Container(
                  color: Colors.grey,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ListHeaderSkeleton(),
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
    required this.onDelete,
    required this.style,
    required this.scrollController,
    required this.detailRouteName,
  }) : super(key: key);

  final List<T> items;
  final int viewIndex;
  final void Function(T) onDelete;
  final ListStyle style;
  final ScrollController scrollController;

  final String detailRouteName;

  @override
  Widget build(BuildContext context) {
    final String computedViewTitle = viewTitle(context);

    return Column(
      children: <Widget>[
        computedViewTitle.isNotEmpty
            ? Container(
                color: Colors.grey,
                child: ListHeader(
                  text: computedViewTitle,
                ),
              )
            : const SizedBox(),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            child: listBuilder(context, scrollController),
          ),
        ),
      ],
    );
  }

  @nonVirtual
  Widget confirmDelete(BuildContext context, T item) {
    return AlertDialog(
      title: HeaderText(AppLocalizations.of(context)!.deleteString),
      content: ListTile(
        title: Text(
          AppLocalizations.of(context)!.deleteDialogTitle(itemTitle(item)),
        ),
        subtitle: Text(AppLocalizations.of(context)!.deleteDialogSubtitle),
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
          child: Text(AppLocalizations.of(context)!.deleteButtonLabel),
        ),
      ],
    );
  }

  @protected
  Widget listBuilder(BuildContext context, ScrollController scrollController) {
    final String computedEmptyTitle =
        AppLocalizations.of(context)!.emptyString(typesName(context));

    switch (style) {
      case ListStyle.card:
        return ItemCardView<T>(
          items: items,
          itemBuilder: cardBuilder,
          emptyTitle: computedEmptyTitle,
          onDismiss: onDelete,
          confirmDelete: confirmDelete,
          scrollController: scrollController,
        );
      case ListStyle.grid:
        return ItemGridView<T>(
          items: items,
          itemBuilder: gridBuilder,
          emptyTitle: computedEmptyTitle,
          onDismiss: onDelete,
          confirmDelete: confirmDelete,
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
  String typesName(BuildContext context);
  String viewTitle(BuildContext context);

  Widget cardBuilder(BuildContext context, T item);
  external Widget gridBuilder(BuildContext context, T item);
}

class ItemCardView<T extends PrimaryModel> extends StatelessWidget {
  const ItemCardView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.emptyTitle,
    required this.onDismiss,
    required this.confirmDelete,
    required this.scrollController,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final String emptyTitle;
  final void Function(T item) onDismiss;
  final Widget Function(BuildContext, T) confirmDelete;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ItemListBuilder(
      itemCount: items.length,
      emptyTitle: emptyTitle,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        final T item = items.elementAt(index);

        return DismissibleItem(
          itemWidget: itemBuilder(context, item),
          onDismissed: () {
            onDismiss(item);
          },
          confirmDismiss: () async {
            return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return confirmDelete(context, item);
              },
            ).then((bool? value) => value ?? false);
          },
          dismissIcon: AppTheme.deleteIcon,
          dismissLabel: AppLocalizations.of(context)!.deleteString,
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
    required this.emptyTitle,
    required this.onDismiss,
    required this.confirmDelete,
    required this.scrollController,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final String emptyTitle;
  final void Function(T item) onDismiss;
  final Widget Function(BuildContext, T) confirmDelete;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ItemGridBuilder(
      itemCount: items.length,
      emptyTitle: emptyTitle,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        final T item = items.elementAt(index);

        return DismissibleItem(
          itemWidget: itemBuilder(context, item),
          onDismissed: () {
            onDismiss(item);
          },
          confirmDismiss: () async {
            return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return confirmDelete(context, item);
              },
            ).then((bool? value) => value ?? false);
          },
          dismissIcon: AppTheme.deleteIcon,
          dismissLabel: AppLocalizations.of(context)!.deleteString,
        );
      },
    );
  }
}
