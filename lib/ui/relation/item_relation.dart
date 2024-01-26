import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart' show PrimaryModel;

import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/item_view.dart';

import '../detail/detail_arguments.dart';
import '../search/search_arguments.dart';
import '../theme/theme.dart' show AppTheme;

abstract class ItemRelationList<
        W extends PrimaryModel,
        K extends Bloc<ItemRelationEvent, ItemRelationState>,
        S extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState>>
    extends StatelessWidget {
  const ItemRelationList({
    Key? key,
    required this.relationIcon,
    required this.relationName,
    required this.relationTypeName,
    this.limitHeight = true,
    this.isSingleList = false,
    required this.hasImage,
    required this.detailRouteName,
    required this.searchRouteName,
  }) : super(key: key);

  final IconData relationIcon;
  final String relationName;
  final String relationTypeName;
  final bool limitHeight;
  final bool isSingleList;
  final bool hasImage;

  final String detailRouteName;
  final String searchRouteName;

  @override
  Widget build(BuildContext context) {
    return BlocListener<S, ItemRelationManagerState>(
      listener: (BuildContext context, ItemRelationManagerState state) {
        if (state is ItemRelationAdded) {
          final String message =
              AppLocalizations.of(context)!.linkedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
          );
        }
        if (state is ItemRelationNotAdded) {
          final String message = AppLocalizations.of(context)!
              .unableToLinkString(relationTypeName);
          showApiErrorSnackbar(
            context,
            name: message,
            error: state.error,
            errorDescription: state.errorDescription,
          );
        }
        if (state is ItemRelationDeleted) {
          final String message =
              AppLocalizations.of(context)!.unlinkedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
          );
        }
        if (state is ItemRelationNotDeleted) {
          final String message = AppLocalizations.of(context)!
              .unableToUnlinkString(relationTypeName);
          showApiErrorSnackbar(
            context,
            name: message,
            error: state.error,
            errorDescription: state.errorDescription,
          );
        }
        if (state is ItemRelationNotLoaded) {
          final String message = AppLocalizations.of(context)!
              .unableToLoadString(relationTypeName);
          showApiErrorSnackbar(
            context,
            name: message,
            error: state.error,
            errorDescription: state.errorDescription,
          );
        }
      },
      child: BlocBuilder<K, ItemRelationState>(
        builder: (BuildContext context, ItemRelationState state) {
          if (state is ItemRelationError) {
            return ItemError(
              title: AppLocalizations.of(context)!.somethingWentWrongString,
              onRetryTap: () =>
                  BlocProvider.of<K>(context).add(ReloadItemRelation()),
            );
          }

          Widget relationListWidget = const SizedBox();
          bool showLinkButton = isSingleList;
          String extraHeaderText = '';
          if (state is ItemRelationLoaded<W>) {
            final List<W> otherItems = state.otherItems;
            relationListWidget = ItemListBuilder(
              canBeDragged: true,
              itemCount: otherItems.length,
              itemBuilder: (BuildContext context, int index) {
                final W relation = otherItems[index];

                return DismissibleItem(
                  itemWidget: cardBuilder(context, relation),
                  onDismissed: () {
                    _deleteRelationFunction(context)(relation);
                  },
                  dismissIcon: AppTheme.unlinkIcon,
                  dismissLabel: AppLocalizations.of(context)!
                      .unlinkString(relationTypeName),
                );
              },
            );
            showLinkButton = isSingleList ? otherItems.isEmpty : true;
            extraHeaderText = isSingleList
                ? ''
                : otherItems.isNotEmpty
                    ? ' (${otherItems.length})'
                    : '';
          }
          if (state is ItemRelationLoading) {
            relationListWidget = SkeletonItemList(
              single: isSingleList,
              canBeDragged: true,
              itemHasImage: hasImage,
            );
            showLinkButton = isSingleList;
          }

          return _RelationList(
            headerIcon: relationIcon,
            headerText: '$relationName$extraHeaderText',
            relationList: isSingleList
                ? relationListWidget
                : Container(
                    constraints: limitHeight
                        ? BoxConstraints.loose(
                            Size.fromHeight(
                              (MediaQuery.of(context).size.height / 3),
                            ),
                          )
                        : null,
                    child: relationListWidget,
                  ),
            linkWidget: showLinkButton
                ? _LinkButton<W>(
                    typeName: relationTypeName,
                    onSearch: onSearchTap(context),
                    updateAdd: _addRelationFunction(context),
                  )
                : null,
            reload: () => BlocProvider.of<K>(context).add(ReloadItemRelation()),
          );
        },
      ),
    );
  }

  void Function(W) _addRelationFunction(BuildContext context) {
    return (W addedItem) {
      BlocProvider.of<S>(context).add(
        AddItemRelation<W>(
          addedItem,
        ),
      );
    };
  }

  void Function(W) _deleteRelationFunction(BuildContext context) {
    return (W deletedItem) {
      BlocProvider.of<S>(context).add(
        DeleteItemRelation<W>(
          deletedItem,
        ),
      );
    };
  }

  Future<W?> Function() onSearchTap(BuildContext context) {
    return () {
      return Navigator.pushNamed<W>(
        context,
        searchRouteName,
        arguments: const SearchArguments(
          onTapReturn: true,
        ),
      );
    };
  }

  @nonVirtual
  void Function()? onTap(BuildContext context, W item) {
    return detailRouteName.isNotEmpty
        ? () async {
            Navigator.pushNamed(
              context,
              detailRouteName,
              arguments: DetailArguments<W>(
                item: item,
                onChange: () {
                  // Reload list if changes were made
                  BlocProvider.of<K>(context).add(ReloadItemRelation());
                },
              ),
            );
          }
        : null;
  }

  Widget cardBuilder(BuildContext context, W item);
}

class _RelationList extends StatelessWidget {
  const _RelationList({
    Key? key,
    required this.headerIcon,
    required this.headerText,
    required this.relationList,
    this.linkWidget,
    required this.reload,
  }) : super(key: key);

  final IconData headerIcon;
  final String headerText;
  final Widget relationList;
  final Widget? linkWidget;
  final void Function() reload;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const ListDivider(),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
          ),
          child: Column(
            children: <Widget>[
              ListHeader(
                icon: headerIcon,
                text: headerText,
                trailingWidget: IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: AppLocalizations.of(context)!.retryString,
                  onPressed: reload,
                ),
              ),
              relationList,
              SizedBox(
                width: double.maxFinite,
                child: linkWidget,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LinkButton<W extends PrimaryModel> extends StatelessWidget {
  const _LinkButton({
    Key? key,
    required this.typeName,
    required this.onSearch,
    required this.updateAdd,
  }) : super(key: key);

  final String typeName;
  final Future<W?> Function() onSearch;
  final void Function(W) updateAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: ElevatedButton.icon(
        label: Text(AppLocalizations.of(context)!.linkString(typeName)),
        icon: const Icon(AppTheme.linkIcon),
        onPressed: () async {
          onSearch().then((W? result) {
            if (result != null) {
              updateAdd(result);
            }
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: AppTheme.defaultThemeTextColor(context),
          backgroundColor: AppTheme.defaultBackgroundColor(context),
          surfaceTintColor: AppTheme.defaultThemeSurfaceTintColor(context),
        ),
      ),
    );
  }
}
