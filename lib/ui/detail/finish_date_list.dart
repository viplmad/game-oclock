import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logic/model/model.dart' show ItemFinish;
import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/show_date_picker.dart';
import 'package:game_oclock/ui/common/skeleton.dart';
import 'package:game_oclock/ui/utils/field_utils.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../theme/theme.dart' show AppTheme;

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
    final String shownValue =
        value != null ? AppLocalizationsUtils.formatDate(value!) : '';

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
        if (state is ItemRelationAdded) {
          _changesMade = true;

          final String message =
              AppLocalizations.of(context)!.addedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
          );
        }
        if (state is ItemRelationNotAdded) {
          final String message =
              AppLocalizations.of(context)!.unableToAddString(relationTypeName);
          showErrorSnackbar(
            context,
            title: message,
            error: state.error,
            errorDescription: state.errorDescription,
          );
        }
        if (state is ItemRelationDeleted) {
          _changesMade = true;

          final String message =
              AppLocalizations.of(context)!.deletedString(relationTypeName);
          showSnackBar(
            context,
            message: message,
          );
        }
        if (state is ItemRelationNotDeleted) {
          final String message = AppLocalizations.of(context)!
              .unableToDeleteString(relationTypeName);
          showErrorSnackbar(
            context,
            title: message,
            error: state.error,
            errorDescription: state.errorDescription,
          );
        }
        if (state is ItemRelationNotLoaded) {
          final String message = AppLocalizations.of(context)!
              .unableToLoadString(relationTypeName);
          showErrorSnackbar(
            context,
            title: message,
            error: state.error,
            errorDescription: state.errorDescription,
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
          return PopScope(
            canPop: true,
            onPopInvoked: (bool didPop) {
              if (_changesMade) {
                onChange();
              }
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
                          AppLocalizations.of(context)!.emptyFinishDatesString,
                        );
                      }

                      return ItemListBuilder(
                        itemCount: values.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DateTime finishDate =
                              values.elementAt(index).date;
                          final String dateString =
                              AppLocalizationsUtils.formatDate(finishDate);

                          return ListTile(
                            title: Text(dateString),
                            trailing: IconButton(
                              icon: const Icon(AppTheme.unlinkIcon),
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

                    if (state is ItemRelationError) {
                      return ItemError(
                        title: AppLocalizations.of(context)!
                            .somethingWentWrongString,
                        onRetryTap: () => BlocProvider.of<K>(context)
                            .add(ReloadItemRelation()),
                      );
                    }

                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LinearProgressIndicator(),
                      ],
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.addString(relationTypeName),
                  ),
                  onPressed: () {
                    showGameDatePicker(
                      context: context,
                    ).then((DateTime? value) {
                      if (value != null) {
                        BlocProvider.of<S>(outerContext).add(
                          AddItemRelation<DateTime>(value),
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
