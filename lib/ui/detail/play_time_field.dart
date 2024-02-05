import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart' show GameLogDTO, NewGameLogDTO;

import 'package:logic/bloc/item_relation/item_relation.dart';
import 'package:logic/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/common/skeleton.dart';
import 'package:game_oclock/ui/utils/field_utils.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show GameTheme;

class GameTotalPlayTimeField extends StatelessWidget {
  const GameTotalPlayTimeField({
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
    return BlocListener<GameLogRelationManagerBloc, ItemRelationManagerState>(
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
      child: BlocBuilder<GamePlayTimeRelationBloc, ItemRelationState>(
        builder: (BuildContext context, ItemRelationState state) {
          Widget subtitleWidget = const Text('-');
          if (state is ItemRelationLoaded<GameLogDTO>) {
            final List<GameLogDTO> sessions = state.otherItems;
            final GameLogDTO? firstSession = sessions.lastOrNull;

            final String shownValue = firstSession != null
                ? AppLocalizationsUtils.formatDuration(
                    context,
                    firstSession.time,
                  )
                : '';

            subtitleWidget = BodyText(shownValue);
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
              icon: const Icon(GameTheme.sessionIcon),
              tooltip: AppLocalizations.of(outerContext)!
                  .addString(relationTypeName),
              onPressed: _onAddTap(outerContext, outerContext),
            ),
          );
        },
      ),
    );
  }

  void Function() _onAddTap(BuildContext context, BuildContext blocContext) {
    return () async {
      Navigator.pushNamed<NewGameLogDTO?>(
        context,
        gameLogAssistantRoute,
      ).then((NewGameLogDTO? result) {
        if (result != null) {
          BlocProvider.of<GameLogRelationManagerBloc>(blocContext).add(
            AddItemRelation<NewGameLogDTO>(
              result,
            ),
          );
        }
      });
    };
  }
}
