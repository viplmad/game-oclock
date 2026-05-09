import 'package:flutter/material.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show gameStatusOptions, sourceIgdb;
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';

class ExternalGameTileListItem extends StatelessWidget {
  const ExternalGameTileListItem({
    super.key,
    required this.data,
    required this.onTap,
    required this.onAddSucceeded,
  });

  final PotentialMediaDTO data;
  final VoidCallback onTap;
  final ValueChanged<BuildContext> onAddSucceeded;

  @override
  Widget build(final BuildContext context) {
    final listItem = TileListItem(
      title: data.media.edition.isEmpty
          ? data.media.title
          : context.localize().gameEditionDataTitle(
              data.media.title,
              data.media.edition,
            ),
      subtitle: data.media.releaseDate == null
          ? null
          : MaterialLocalizations.of(
              context,
            ).formatYear(data.media.releaseDate!),
      imageURL: data.media.imageUrl,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (data.state == null)
            IconButton(
              icon: CommonIcons.add,
              tooltip: context.localize().addLabel,
              onPressed: () => showReturningDialog(
                context,
                builder: (final context) =>
                    UserGameExternalCreateForm(externalId: data.external_),
                onSuccess: (final context, _) => onAddSucceeded(context),
              ),
            ),
          if (data.state != null)
            LabelChoiceChip(
              value: data.state!.status.toJson(),
              options: gameStatusOptions,
            ),
          data.external_.source_ == sourceIgdb
              ? CommonIcons.externalSourceIgdb
              : CommonIcons.externalSourceDefault,
        ],
      ),
      onTap: onTap,
    );

    return addRatingBanner(listItem, data.state?.rating ?? 0);
  }
}
