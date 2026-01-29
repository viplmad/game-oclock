import 'package:flutter/material.dart';
import 'package:game_oclock/components/cached_image.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show ExternalGame, UserGame, gameStatusOptions;
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';

class ExternalGameDetail extends StatelessWidget {
  const ExternalGameDetail({
    super.key,
    required this.data,
    required this.onBackPressed,
    required this.onAddSucceeded,
  });

  final ExternalGame data;
  final VoidCallback onBackPressed;
  final ValueChanged<BuildContext> onAddSucceeded;

  @override
  Widget build(final BuildContext context) {
    return Detail(
      title: Text(data.title),
      image: data.imageUrl == null
          ? null
          : SimpleCachedNetworkImage(
              imageUrl: data.imageUrl!,
              fit: BoxFit.cover,
              applyGradient: true,
            ),
      onBackPressed: onBackPressed,
      actions: [
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
      ],
      child: _info(context),
    );
  }

  Widget _info(final BuildContext context) {
    return SingleChildScrollView(
      child: LabelsContainer(
        children: [
          TextLabel(
            label: context.localize().sourceLabel,
            value: data.externalId.source,
          ),
          TextLabel(
            label: context.localize().idLabel,
            value: data.externalId.id,
          ),
          TextLabel(label: context.localize().titleLabel, value: data.title),
          TextLabel(
            label: context.localize().editionLabel,
            value: data.edition,
          ),
          DateLabel(
            label: context.localize().releaseDateLabel,
            value: data.releaseDate,
          ),
          if (data.userInfo != null)
            ChoiceLabel(
              label: context.localize().statusLabel,
              value: data.userInfo!.status,
              options: gameStatusOptions,
            ),
          if (data.userInfo != null)
            RatingLabel(
              label: context.localize().ratingLabel,
              value: data.userInfo!.rating,
              color: CommonColors.ratingColor,
            ),
          if (data.userInfo != null)
            TextLabel(
              label: context.localize().notesLabel,
              value: data.userInfo!.notes,
              multiline: true,
            ),
          MultipleTextLabel(
            label: context.localize().genresLabel,
            value: data.genres,
          ),
          MultipleTextLabel(
            label: context.localize().seriesLabel,
            value: data.series,
          ),
        ],
      ),
    );
  }
}
