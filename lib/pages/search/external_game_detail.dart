import 'package:flutter/material.dart';
import 'package:game_oclock/components/cached_image.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show gameStatusOptions;
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';

class ExternalGameDetail extends StatelessWidget {
  const ExternalGameDetail({
    super.key,
    required this.data,
    required this.onBackPressed,
    required this.onAddSucceeded,
  });

  final PotentialMediaDTO data;
  final VoidCallback onBackPressed;
  final ValueChanged<BuildContext> onAddSucceeded;

  @override
  Widget build(final BuildContext context) {
    return Detail(
      title: Text(data.media.title),
      image: data.media.imageUrl == null
          ? null
          : SimpleCachedNetworkImage(
              imageUrl: data.media.imageUrl!,
              fit: BoxFit.cover,
              applyGradient: true,
            ),
      onBackPressed: onBackPressed,
      actions: [
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
      ],
      child: _info(context),
    );
  }

  Widget _info(final BuildContext context) {
    return SingleChildScrollView(
      child: LabelsContainer(
        children: [
          TextLabel(
            icon: CommonIcons.source,
            label: context.localize().sourceLabel,
            value: data.external_.source_,
          ),
          TextLabel(
            icon: CommonIcons.id,
            label: context.localize().idLabel,
            value: data.external_.id,
          ),
          TextLabel(
            icon: CommonIcons.title,
            label: context.localize().titleLabel,
            value: data.media.title,
          ),
          TextLabel(
            icon: CommonIcons.edition,
            label: context.localize().editionLabel,
            value: data.media.edition,
          ),
          DateLabel(
            icon: CommonIcons.release,
            label: context.localize().releaseDateLabel,
            value: data.media.releaseDate,
          ),
          if (data.state != null)
            ChoiceLabel(
              icon: CommonIcons.status,
              label: context.localize().statusLabel,
              value: data.state!.status.toJson(),
              options: gameStatusOptions,
            ),
          if (data.state != null)
            RatingLabel(
              icon: CommonIcons.rating,
              label: context.localize().ratingLabel,
              value: data.state!.rating,
              color: CommonColors.rating,
            ),
          if (data.state != null)
            TextLabel(
              icon: CommonIcons.notes,
              label: context.localize().notesLabel,
              value: data.state!.notes,
              multiline: true,
            ),
          MultipleTextLabel(
            icon: CommonIcons.genre,
            label: context.localize().genresLabel,
            value: data.media.genres
                .map(context.localize().genreLabel)
                .toList(growable: false),
          ),
          MultipleTextLabel(
            icon: CommonIcons.series,
            label: context.localize().seriesLabel,
            value: data.media.series,
          ),
        ],
      ),
    );
  }
}
