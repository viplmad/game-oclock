import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess,
        DevicePlayedGameListBloc,
        ListInitial,
        ListLoadBloc,
        ListSearchChanged,
        LocationAvailableListBloc,
        TagOfGameListBloc,
        UserGameDeleteBloc,
        UserGameFinishesGetBloc,
        UserGameGetBloc,
        UserGameSyncBloc,
        UserGameTotalTimeGetBloc,
        UserGameUnsyncBloc;
import 'package:game_oclock/components/cached_image.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/error_detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list_detail.dart'
    show RelationListBuilder;
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show LayoutTier, TabDestination, gameStatusOptions;
import 'package:game_oclock/shared/forms/game_available_form.dart';
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/forms/game_tag_form.dart';
import 'package:game_oclock/shared/forms/location_form.dart';
import 'package:game_oclock/shared/forms/tag_form.dart';
import 'package:game_oclock/shared/list_item/device_list_item.dart';
import 'package:game_oclock/shared/list_item/game_available_list_item.dart';
import 'package:game_oclock/shared/list_item/media_tagged_list_item.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:game_oclock_client/api.dart';
import 'package:go_router/go_router.dart';

class UserGameDetailPage extends StatelessWidget {
  const UserGameDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              UserGameGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameTotalTimeGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameFinishesGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameSyncBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameUnsyncBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => LocationAvailableListBloc(
            service: RepositoryProvider.of(context),
            gameId: id,
          ),
        ),
        BlocProvider(
          create: (_) => TagOfGameListBloc(
            service: RepositoryProvider.of(context),
            gameId: id,
          ),
        ),
        BlocProvider(
          create: (_) => DevicePlayedGameListBloc(
            service: RepositoryProvider.of(context),
            gameId: id,
          ),
        ),
      ],
      child: DetailBuilder<MediaDTO, UserGameGetBloc>(
        onBackPressed: () => GoRouter.of(context).go(CommonPaths.gamesPath),
        builder: (final context, final data, final onBackPressed) =>
            UserGameDetail(
              data: data,
              fromPage: true,
              extended: layoutTier != LayoutTier.compact,
              onBackPressed: onBackPressed,
              onEditSucceeded: (final context) =>
                  context.read<UserGameGetBloc>().add(const ActionRestarted()),
              onDeleteSucceeded: (final context) =>
                  GoRouter.of(context).go(CommonPaths.gamesPath),
            ),
      ),
    );
  }
}

class UserGameDetail extends StatelessWidget {
  const UserGameDetail({
    super.key,
    required this.data,
    this.fromPage = false,
    required this.extended,
    required this.onBackPressed,
    required this.onEditSucceeded,
    required this.onDeleteSucceeded,
  });

  final MediaDTO data;
  final VoidCallback onBackPressed;
  final bool fromPage;
  final bool extended;
  final ValueChanged<BuildContext> onEditSucceeded;
  final ValueChanged<BuildContext> onDeleteSucceeded;

  @override
  Widget build(final BuildContext context) {
    final mainTab = TabDestination(
      icon: CommonIcons.detail,
      labelBuilder: (final context) => context.localize().detailLabel,
      onTap: (_) {},
      child: _info(context),
    );

    final List<TabDestination> tabs = List.unmodifiable(<TabDestination>[
      TabDestination(
        icon: CommonIcons.locations,
        labelBuilder: (final context) => context.localize().locationsTitle,
        onTap: (final context) =>
            _loadOnlyInitial<LocationAvailableListBloc>(context),
        child:
            RelationListBuilder<
              LocationAvailableDTO,
              LocationAvailableListBloc
            >(
              createFormBuilder: ([final quicksearch]) =>
                  GameAvailableCreateForm(
                    gameId: data.media.id,
                    locationId: quicksearch,
                  ),
              searchCreateFormBuilder: (final quicksearch) =>
                  LocationCreateForm(initialName: quicksearch),
              itemBuilder: (final context, final data) =>
                  LocationWithDateTileListItem(
                    data: data,
                    onTap: () => GoRouter.of(
                      context,
                    ).go(CommonPaths.buildLocationPath(data.location.id)),
                  ),
            ),
      ),
      TabDestination(
        icon: CommonIcons.tags,
        labelBuilder: (final context) => context.localize().tagsTitle,
        onTap: (final context) => _loadOnlyInitial<TagOfGameListBloc>(context),
        child: RelationListBuilder<TagMediaDTO, TagOfGameListBloc>(
          createFormBuilder: ([final quicksearch]) =>
              GameTagCreateForm(gameId: data.media.id, tagId: quicksearch),
          searchCreateFormBuilder: (final quicksearch) =>
              TagCreateForm(initialName: quicksearch),
          itemBuilder: (final context, final data) => TagMediaTileListItem(
            data: data,
            onTap: () =>
                GoRouter.of(context).go(CommonPaths.buildTagPath(data.tag.id)),
          ),
        ),
      ),
      TabDestination(
        icon: CommonIcons.devices,
        labelBuilder: (final context) => context.localize().devicesTitle,
        onTap: (final context) =>
            _loadOnlyInitial<DevicePlayedGameListBloc>(context),
        child: RelationListBuilder<DeviceDTO, DevicePlayedGameListBloc>(
          itemBuilder: (final context, final data) => DeviceTileListItem(
            data: data,
            onTap: () =>
                GoRouter.of(context).go(CommonPaths.buildDevicePath(data.id)),
          ),
        ),
      ),
    ]);

    return MultiBlocListener(
      listeners: [
        BlocListener<UserGameDeleteBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, MediaDTO>) {
              showSnackBar(
                context,
                message: context.localize().deletedSuccessfullyLabel,
              );
              onDeleteSucceeded(context);
            }
            if (state is ActionFailure<void, MediaDTO>) {
              showErrorSnackBar(
                context,
                name: context.localize().unableToDeleteLabel,
                error: state.error,
              );
            }
          },
        ),
        BlocListener<UserGameSyncBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, MediaDTO>) {
              showSnackBar(
                context,
                message: context.localize().syncedSuccessfullyLabel,
              );
              onEditSucceeded(context);
            }
            if (state is ActionFailure<void, MediaDTO>) {
              showErrorSnackBar(
                context,
                name: context.localize().unableToSyncLabel,
                error: state.error,
              );
            }
          },
        ),
        BlocListener<UserGameUnsyncBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, MediaDTO>) {
              showSnackBar(
                context,
                message: context.localize().unsyncedSuccessfullyLabel,
              );
              onEditSucceeded(context);
            }
            if (state is ActionFailure<void, MediaDTO>) {
              showErrorSnackBar(
                context,
                name: context.localize().unableToUnsyncLabel,
                error: state.error,
              );
            }
          },
        ),
      ],
      child: DetailWithTabs(
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
          IconButton(
            icon: CommonIcons.calendar,
            tooltip: context.localize().calendarLabel,
            onPressed: () => GoRouter.of(
              context,
            ).go(CommonPaths.buildGameCalendarPath(data.media.id)),
          ),
          if (!fromPage)
            IconButton(
              icon: CommonIcons.view,
              tooltip: context.localize().viewLabel,
              onPressed: () => GoRouter.of(
                context,
              ).go(CommonPaths.buildGamePath(data.media.id)),
            ),
          IconButton(
            icon: CommonIcons.edit,
            tooltip: context.localize().editLabel,
            onPressed: () async => showReturningDialog(
              context,
              builder: (final context) => UserGameEditForm(id: data.media.id),
              onSuccess: (final context, _) => onEditSucceeded(context),
            ),
          ),
          IconButton(
            icon: CommonIcons.sync,
            tooltip: context.localize().syncLabel,
            onPressed: () =>
                context.read<UserGameSyncBloc>().add(ActionStarted(data: data)),
          ),
          IconButton(
            icon: CommonIcons.unsync,
            tooltip: context.localize().unsyncLabel,
            onPressed: () => context.read<UserGameUnsyncBloc>().add(
              ActionStarted(data: data),
            ),
          ),
          IconButton(
            icon: CommonIcons.delete,
            tooltip: context.localize().deleteLabel,
            onPressed: () async => showConfirmationDialog(
              context,
              builder: (final context) => ConfirmationDialog(
                title: context.localize().deleteDialogTitle,
                subtitle: context.localize().deleteDialogSubtitle,
                message: context.localize().deleteDialogDataTitle(
                  data.media.title,
                ),
                acceptLabel: MaterialLocalizations.of(
                  context,
                ).deleteButtonTooltip,
              ),
              onSuccess: (final context) {
                context.read<UserGameDeleteBloc>().add(
                  ActionStarted(data: data),
                );
              },
            ),
          ),
        ],
        extended: extended,
        mainTab: mainTab,
        tabs: tabs,
      ),
    );
  }

  Widget _info(final BuildContext context) {
    return SingleChildScrollView(
      child: LabelsContainer(
        children: [
          TextLabel(
            icon: CommonIcons.id,
            label: context.localize().idLabel,
            value: data.media.id,
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
          ChoiceLabel(
            icon: CommonIcons.status,
            label: context.localize().statusLabel,
            value: data.state.status.toJson(),
            options: gameStatusOptions,
          ),
          RatingLabel(
            icon: CommonIcons.rating,
            label: context.localize().ratingLabel,
            value: data.state.rating,
            color: CommonColors.rating,
          ),
          TextLabel(
            icon: CommonIcons.notes,
            label: context.localize().notesLabel,
            value: data.state.notes,
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
          GetBuilder<Duration, UserGameTotalTimeGetBloc>(
            skeletonBuilder: (final context) => LabelSkeleton(
              order: 0,
              icon: CommonIcons.time,
              label: context.localize().totalTimeLabel,
            ),
            errorBuilder: (final context, final onRetryTap) => Center(
              child: LabelError(
                label: context.localize().errorTotalTimeLoadTitle,
                onRetryTap: onRetryTap,
              ),
            ),
            builder: (final context, final data) => DurationLabel(
              icon: CommonIcons.time,
              label: context.localize().totalTimeLabel,
              value: data,
            ),
          ),
          GetBuilder<List<SessionDTO>, UserGameFinishesGetBloc>(
            skeletonBuilder: (final context) => LabelSkeleton(
              order: 1,
              icon: CommonIcons.finished,
              label: context.localize().finishedLabel,
            ),
            errorBuilder: (final context, final onRetryTap) => Center(
              child: LabelError(
                label: context.localize().errorFinishesLoadTitle,
                onRetryTap: onRetryTap,
              ),
            ),
            builder: (final context, final data) => TextLabel(
              icon: CommonIcons.finished,
              label: context.localize().finishedLabel,
              value: data.isEmpty
                  ? null
                  : MaterialLocalizations.of(
                          context,
                        ).formatCompactDate(data.first.startDatetime) +
                        (data.length > 1 ? '(+)' : ''),
            ),
          ),
        ],
      ),
    );
  }

  void _loadOnlyInitial<LB extends ListLoadBloc>(final BuildContext context) {
    final lb = context.read<LB>();
    if (lb.state is ListInitial) {
      lb.add(ListSearchChanged(search: ListSearchDTO()));
    }
  }
}
