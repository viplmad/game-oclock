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
import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/utils/field_utils.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../theme/theme.dart' show AppTheme, GameTheme;

class FinishList<K extends Bloc<ItemRelationEvent, ItemRelationState>,
        S extends Bloc<ItemRelationManagerEvent, ItemRelationManagerState>>
    extends StatelessWidget {
  const FinishList({
    super.key,
    required this.fieldName,
    required this.relationTypeName,
    this.skeletonOrder = 0,
  });

  final String fieldName;
  final String relationTypeName;
  final int skeletonOrder;

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext outerContext) {
    return BlocListener<S, ItemRelationManagerState>(
      listener: (BuildContext context, ItemRelationManagerState state) {
        if (state is ItemRelationAdded) {
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
          showApiErrorSnackbar(
            context,
            name: message,
            error: state.error,
            errorDescription: state.errorDescription,
          );
        }
        if (state is ItemRelationDeleted) {
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
          Widget subtitleWidget = const Text('-');
          if (state is ItemRelationLoaded<ItemFinish>) {
            final List<ItemFinish> finishes = state.otherItems;
            final ItemFinish? firstFinish = finishes.lastOrNull;

            final String shownValue = firstFinish != null
                ? AppLocalizationsUtils.formatDate(finishes.last.date)
                : '';
            final String extra = finishes.length > 1 ? '(+)' : '';

            subtitleWidget = BodyText('$shownValue $extra');
          }
          if (state is ItemRelationLoading) {
            subtitleWidget = Skeleton(
              width: FieldUtils.subtitleTextWidth,
              height: FieldUtils.subtitleTextHeight,
              order: skeletonOrder,
            );
          }

          return FieldListTile(
            title: HeaderText(fieldName),
            subtitle: subtitleWidget,
            trailing: IconButton(
              icon: const Icon(GameTheme.finishedIcon),
              tooltip: AppLocalizations.of(outerContext)!
                  .addString(relationTypeName),
              onPressed: _onAddTap(outerContext, outerContext),
            ),
            onTap: _onTap(outerContext),
          );
        },
      ),
    );
  }

  void Function() _onTap(BuildContext outerContext) {
    return () async {
      showDialog(
        context: outerContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: HeaderText(fieldName),
            content: SizedBox(
              width: double.maxFinite,
              child: BlocBuilder<K, ItemRelationState>(
                bloc: BlocProvider.of<K>(outerContext),
                builder: (BuildContext context, ItemRelationState state) {
                  if (state is ItemRelationLoaded<ItemFinish>) {
                    final List<ItemFinish> values = state.otherItems;

                    return ItemListBuilder(
                      itemCount: values.length,
                      emptyTitle:
                          AppLocalizations.of(context)!.emptyFinishDatesString,
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
                      onRetryTap: () =>
                          BlocProvider.of<K>(context).add(ReloadItemRelation()),
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
                onPressed: _onAddTap(context, outerContext),
                child: Text(
                  AppLocalizations.of(context)!.addString(relationTypeName),
                ),
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
          );
        },
      );
    };
  }

  void Function() _onAddTap(BuildContext context, BuildContext blocContext) {
    return () async {
      showGameDatePicker(
        context: context,
      ).then((DateTime? value) {
        if (value != null) {
          BlocProvider.of<S>(blocContext).add(
            AddItemRelation<DateTime>(value),
          );
        }
      });
    };
  }
}
