import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show ItemFinish;
import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/list_view.dart';
import '../common/show_snackbar.dart';
import '../common/show_date_picker.dart';
import '../common/skeleton.dart';
import '../utils/field_utils.dart';

// ignore: must_be_immutable
abstract class FinishList<K extends Bloc<ItemRelationEvent, ItemRelationState>,
        S extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState>>
    extends _FinishList<K, S> {
  FinishList({
    Key? key,
    required super.fieldName,
    required this.value,
    required super.relationTypeName,
    required super.onChange,
  }) : super(key: key);

  final DateTime? value;

  @override
  Widget fieldBuilder(BuildContext context) {
    final String shownValue = value != null
        ? GameCollectionLocalisations.of(context).formatDate(value!)
        : '';

    return BlocBuilder<K, ItemRelationState>(
      builder: (BuildContext context, ItemRelationState state) {
        String extra = '';
        if (state is ItemRelationLoaded<ItemFinish>) {
          extra = state.otherItems.length > 1 ? '(+)' : '';
        }

        return Text('$shownValue $extra');
      },
    );
  }
}

// ignore: must_be_immutable
abstract class SkeletonFinishList<
        K extends Bloc<ItemRelationEvent, ItemRelationState>,
        S extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState>>
    extends _FinishList<K, S> {
  SkeletonFinishList({
    Key? key,
    required super.fieldName,
    required super.relationTypeName,
    this.order = 0,
    required super.onChange,
  }) : super(key: key);

  final int order;

  @override
  Widget fieldBuilder(BuildContext context) {
    return Skeleton(
      width: FieldUtils.subtitleTextWidth,
      height: FieldUtils.subtitleTextHeight,
      order: order,
    );
  }
}

// ignore: must_be_immutable
abstract class _FinishList<K extends Bloc<ItemRelationEvent, ItemRelationState>,
        S extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState>>
    extends StatelessWidget {
  _FinishList({
    Key? key,
    required this.fieldName,
    required this.relationTypeName,
    required this.onChange,
  }) : super(key: key);

  final String fieldName;
  final String relationTypeName;
  final void Function() onChange;

  bool _changesMade = false;

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext outerContext) {
    return BlocListener<S, ItemRelationManagerState>(
      listener: (BuildContext context, ItemRelationManagerState state) {
        if (state is ItemRelationAdded<ItemFinish>) {
          _changesMade = true;

          final String message = GameCollectionLocalisations.of(context)
              .addedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
          );
        }
        if (state is ItemRelationNotAdded) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToAddString(relationTypeName);
          showSnackBar(
            context,
            message: message,
            snackBarAction: dialogSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).moreString,
              title: message,
              content: state.error,
            ),
          );
        }
        if (state is ItemRelationDeleted<ItemFinish>) {
          _changesMade = true;

          final String message = GameCollectionLocalisations.of(context)
              .deletedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
          );
        }
        if (state is ItemRelationNotDeleted) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToDeleteString(relationTypeName);
          showSnackBar(
            context,
            message: message,
            snackBarAction: dialogSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).moreString,
              title: message,
              content: state.error,
            ),
          );
        }
      },
      child: ListTileTheme.merge(
        child: ListTile(
          title: Text(fieldName),
          trailing: fieldBuilder(outerContext),
          onTap: _onTap(outerContext),
        ),
      ),
    );
  }

  void Function() _onTap(BuildContext outerContext) {
    return () async {
      showDialog(
        context: outerContext,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              if (_changesMade) {
                onChange();
              }
              return true;
            },
            child: AlertDialog(
              title: Text(fieldName),
              content: SizedBox(
                width: double.maxFinite,
                child: BlocBuilder<K, ItemRelationState>(
                  bloc: BlocProvider.of<K>(outerContext),
                  builder: (BuildContext context, ItemRelationState state) {
                    if (state is ItemRelationLoaded<ItemFinish>) {
                      final List<ItemFinish> values = state.otherItems;

                      if (values.isEmpty) {
                        return Text(
                          GameCollectionLocalisations.of(context)
                              .emptyFinishDatesString,
                        );
                      }

                      return ItemListBuilder(
                        itemCount: values.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DateTime finishDate =
                              values.elementAt(index).date;
                          final String dateString =
                              GameCollectionLocalisations.of(context)
                                  .formatDate(finishDate);

                          return ListTile(
                            title: Text(dateString),
                            trailing: IconButton(
                              icon: const Icon(Icons.link_off),
                              onPressed: () {
                                BlocProvider.of<S>(outerContext).add(
                                  DeleteItemRelation<ItemFinish>(
                                    ItemFinish(finishDate),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }

                    if (state is ItemRelationNotLoaded) {
                      return Center(
                        child: Text(state.error),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        LinearProgressIndicator(),
                      ],
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    GameCollectionLocalisations.of(context)
                        .addString(relationTypeName),
                  ),
                  onPressed: () {
                    showGameDatePicker(
                      context: context,
                    ).then((DateTime? value) {
                      if (value != null) {
                        BlocProvider.of<S>(outerContext).add(
                          AddItemRelation<ItemFinish>(ItemFinish(value)),
                        );
                      }
                    });
                  },
                ),
                TextButton(
                  child: Text(
                    MaterialLocalizations.of(context).okButtonLabel,
                  ),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    };
  }

  Widget fieldBuilder(BuildContext context);
}
