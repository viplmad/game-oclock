import 'package:flutter/material.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show ExternalGame, UserGame, gameStatusOptions, sourceIgdb;
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';

class ExternalGameTileListItem extends StatelessWidget {
  const ExternalGameTileListItem({
    super.key,
    required this.data,
    required this.onTap,
    required this.onAddSucceeded,
  });

  final ExternalGame data;
  final VoidCallback onTap;
  final ValueChanged<BuildContext> onAddSucceeded;

  @override
  Widget build(final BuildContext context) {
    final listItem = TileListItem(
      title: data.edition == null || data.edition!.isEmpty
          ? data.title
          : context.localize().gameEditionDataTitle(data.title, data.edition!),
      subtitle: data.releaseDate == null
          ? null
          : MaterialLocalizations.of(context).formatYear(data.releaseDate!),
      imageURL: data.imageUrl,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (data.userInfo == null)
            IconButton(
              icon: CommonIcons.add,
              tooltip: context.localize().addLabel,
              onPressed: () => showFormDialog<UserGame>(
                context,
                builder: (final context) =>
                    UserGameExternalCreateForm(externalData: data),
                onSuccess: (final context, _) => onAddSucceeded(context),
              ),
            ),
          if (data.userInfo != null)
            LabelChoiceChip(
              value: data.userInfo!.status,
              options: gameStatusOptions,
            ),
          data.externalId.source == sourceIgdb
              ? CommonIcons.externalSourceIgdb
              : CommonIcons.externalSourceDefault,
        ],
      ),
      onTap: onTap,
    );

    return addRatingBanner(listItem, data.userInfo?.rating ?? 0);
  }
}
