import 'package:flutter/material.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list/list_item.dart'
    show GridListItem, TileListItem;
import 'package:game_oclock/components/triangle_banner.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show gameStatusOptions;
import 'package:game_oclock/shared/forms/game_session_form.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';

class UserGameTileListItem extends StatelessWidget {
  const UserGameTileListItem({
    super.key,
    required this.data,
    required this.onTap,
    this.onAddSessionSucceeded,
  });

  final MediaDTO data;
  final VoidCallback onTap;
  final ValueChanged<BuildContext>? onAddSessionSucceeded;

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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (onAddSessionSucceeded != null)
            IconButton(
              icon: CommonIcons.addSession,
              tooltip: context.localize().addSessionLabel,
              onPressed: () => showReturningDialog(
                context,
                builder: (final context) =>
                    GameSessionCreateForm(gameId: data.media.id),
                onSuccess: (final context, _) =>
                    onAddSessionSucceeded!(context),
              ),
            ),
          LabelChoiceChip(
            value: data.state.status.toJson(),
            options: gameStatusOptions,
          ),
        ],
      ),
      imageURL: data.media.imageUrl,
      onTap: onTap,
    );

    return addRatingBanner(listItem, data.state.rating);
  }
}

class UserGameGridListItem extends StatelessWidget {
  const UserGameGridListItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final MediaDTO data;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final listItem = GridListItem(
      title: data.media.edition.isEmpty
          ? data.media.title
          : context.localize().gameEditionDataTitle(
              data.media.title,
              data.media.edition,
            ),
      imageURL: data.media.imageUrl,
      onTap: onTap,
    );

    return addRatingBanner(listItem, data.state.rating);
  }
}

Widget addRatingBanner(final Widget listItem, final int rating) {
  return rating > 0
      ? TriangleBanner(
          message: rating.toString(),
          location: TriangleBannerLocation.end,
          showShadow: false,
          color: CommonColors.ratingColor,
          textStyle: const TextStyle(
            color: CommonColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
          child: listItem,
        )
      : listItem;
}
