import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show Item, ItemFinish;

import 'package:backend/bloc/item_relation/item_relation.dart';
import 'package:backend/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../common/show_date_picker.dart';

// ignore: must_be_immutable
abstract class FinishList<
        T extends Item,
        F extends ItemFinish,
        K extends Bloc<ItemRelationEvent, ItemRelationState>,
        S extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState>>
    extends StatelessWidget {
  FinishList({
    Key? key,
    required this.fieldName,
    required this.value,
    required this.relationTypeName,
    required this.onUpdate,
  }) : super(key: key);

  final String fieldName;
  final DateTime? value;
  final String relationTypeName;
  final void Function() onUpdate;

  bool _hasUpdated = false;

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext outerContext) {
    final String shownValue = value != null
        ? GameCollectionLocalisations.of(outerContext).formatDate(value!)
        : '';

    return BlocListener<S, ItemRelationManagerState>(
      listener: (BuildContext context, ItemRelationManagerState state) {
        if (state is ItemRelationAdded<F>) {
          _hasUpdated = true;

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
        if (state is ItemRelationDeleted<F>) {
          _hasUpdated = true;

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
          trailing: BlocBuilder<K, ItemRelationState>(
            builder: (BuildContext context, ItemRelationState state) {
              String extra = '';
              if (state is ItemRelationLoaded<F>) {
                extra = state.otherItems.length > 1 ? '(+)' : '';
              }

              return Text(shownValue + ' ' + extra);
            },
          ),
          onTap: () {
            showDialog(
              context: outerContext,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async {
                    if (_hasUpdated) {
                      onUpdate();
                    }
                    return true;
                  },
                  child: AlertDialog(
                    title: Text(fieldName),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: BlocBuilder<K, ItemRelationState>(
                        bloc: BlocProvider.of<K>(outerContext),
                        builder:
                            (BuildContext context, ItemRelationState state) {
                          if (state is ItemRelationLoaded<F>) {
                            final List<F> values = state.otherItems;

                            if (values.isEmpty) {
                              return Text(
                                GameCollectionLocalisations.of(context)
                                    .emptyFinishDatesString,
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (BuildContext context, int index) {
                                final F finish = values.elementAt(index);
                                final String dateString =
                                    GameCollectionLocalisations.of(context)
                                        .formatDate(finish.dateTime);

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    right: 4.0,
                                    left: 4.0,
                                    bottom: 4.0,
                                    top: 4.0,
                                  ),
                                  child: ListTile(
                                    title: Text(dateString),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.link_off),
                                      onPressed: () {
                                        BlocProvider.of<S>(outerContext).add(
                                          DeleteItemRelation<F>(finish),
                                        );
                                      },
                                    ),
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
                                AddItemRelation<F>(createFinish(value)),
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
          },
        ),
      ),
    );
  }

  F createFinish(DateTime dateTime);
}
