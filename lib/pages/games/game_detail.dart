import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionInProgress,
        ActionInitial,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess,
        DevicePlayedGameListBloc,
        GameChildrenListBloc,
        ListInitial,
        ListLoadBloc,
        ListSearchChanged,
        LocationAvailableListBloc,
        TagOfGameListBloc,
        UserGameDeleteBloc,
        UserGameFinishesGetBloc,
        UserGameGetBloc,
        UserGameParentGetBloc,
        UserGameSyncBloc,
        UserGameTotalTimeGetBloc,
        UserGameUnsyncBloc;
import 'package:game_oclock/components/cached_image.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/error_detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list/list_item.dart'
    show TileListErrorItem;
import 'package:game_oclock/components/list/toolbar.dart' show ListToolbar;
import 'package:game_oclock/components/list_detail.dart'
    show RelationListBuilder;
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show ActionDestination, LayoutTier, TabDestination, gameStatusOptions;
import 'package:game_oclock/shared/forms/game_available_form.dart';
import 'package:game_oclock/shared/forms/game_child_form.dart';
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/forms/game_tag_form.dart';
import 'package:game_oclock/shared/forms/location_form.dart';
import 'package:game_oclock/shared/forms/tag_form.dart';
import 'package:game_oclock/shared/list_item/device_list_item.dart';
import 'package:game_oclock/shared/list_item/game_available_list_item.dart';
import 'package:game_oclock/shared/list_item/media_tagged_list_item.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:game_oclock_client/api.dart';

class UserGameDetailPage extends StatelessWidget {
  const UserGameDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocProvider(
      // Recreate on selection change
      key: Key(id),
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
          create: (_) =>
              UserGameParentGetBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => GameChildrenListBloc(
            service: RepositoryProvider.of(context),
            gameId: id,
          ),
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
        onBackPressed: () =>
            goBack(context, defaultPath: CommonPaths.gamesPath),
        builder: (context, data, onBackPressed) => UserGameDetail(
          data: data,
          fromPage: true,
          extended: layoutTier != LayoutTier.compact,
          onBackPressed: onBackPressed,
          onEditSucceeded: (context) =>
              context.read<UserGameGetBloc>().add(const ActionRestarted()),
          onDeleteSucceeded: (context) =>
              goBack(context, defaultPath: CommonPaths.gamesPath),
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
  Widget build(BuildContext context) {
    final mainTab = TabDestination(
      icon: CommonIcons.detail,
      labelBuilder: (context) => context.localize().detailLabel,
      onTap: (_) {},
      child: _info(context),
    );

    final List<TabDestination> tabs = List.unmodifiable(<TabDestination>[
      TabDestination(
        icon: CommonIcons.dlcs,
        labelBuilder: (context) => context.localize().dlcsTitle,
        onTap: (context) {
          if (data.media.parentId != null) {
            final gb = context.read<UserGameParentGetBloc>();
            if (gb.state is ActionInitial<MediaDTO>) {
              gb.add(ActionStarted(data: data.media.parentId!));
            }
          }
          _loadOnlyInitial<GameChildrenListBloc>(context);
        },
        child: Column(
          children: [
            if (data.media.parentId != null)
              Column(
                children: [
                  ListToolbar(
                    actions: [
                      IconButton(
                        icon: CommonIcons.reload,
                        tooltip: context.localize().reloadLabel,
                        onPressed: () => context
                            .read<UserGameParentGetBloc>()
                            .add(const ActionRestarted()),
                      ),
                    ],
                  ),
                  GetBuilder<MediaDTO, UserGameParentGetBloc>(
                    skeletonBuilder: (context) => const TileListSkeletonItem(),
                    errorBuilder: (context, onRetryTap) => TileListErrorItem(
                      title: context.localize().errorLoadParentGameTitle,
                      onRetryTap: onRetryTap,
                    ),
                    builder: (context, parent) => UserGameWithOrderTileListItem(
                      data: parent,
                      order: data.media.parentOrder,
                      onTap: () => go(
                        context,
                        path: CommonPaths.buildGamePath(parent.media.id),
                      ),
                    ),
                  ),
                ],
              ),
            Expanded(
              child: RelationListBuilder<MediaDTO, GameChildrenListBloc>(
                createFormBuilder: ([quicksearch]) => GameChildCreateForm(
                  parentGameId: data.media.id,
                  childGameId: quicksearch,
                ),
                searchCreateFormBuilder: (quicksearch) =>
                    UserGameCreateForm(initialTitle: quicksearch),
                itemBuilder: (context, child) => UserGameWithOrderTileListItem(
                  data: child,
                  order: child.media.parentOrder,
                  onTap: () => go(
                    context,
                    path: CommonPaths.buildGamePath(child.media.id),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      TabDestination(
        icon: CommonIcons.locations,
        labelBuilder: (context) => context.localize().locationsTitle,
        onTap: (context) =>
            _loadOnlyInitial<LocationAvailableListBloc>(context),
        child:
            RelationListBuilder<
              LocationAvailableDTO,
              LocationAvailableListBloc
            >(
              createFormBuilder: ([quicksearch]) => GameAvailableCreateForm(
                gameId: data.media.id,
                locationId: quicksearch,
              ),
              searchCreateFormBuilder: (quicksearch) =>
                  LocationCreateForm(initialName: quicksearch),
              itemBuilder: (context, data) => LocationWithDateTileListItem(
                data: data,
                onTap: () => go(
                  context,
                  path: CommonPaths.buildLocationPath(data.location.id),
                ),
              ),
            ),
      ),
      TabDestination(
        icon: CommonIcons.tags,
        labelBuilder: (context) => context.localize().tagsTitle,
        onTap: (context) => _loadOnlyInitial<TagOfGameListBloc>(context),
        child: RelationListBuilder<TagMediaDTO, TagOfGameListBloc>(
          createFormBuilder: ([quicksearch]) =>
              GameTagCreateForm(gameId: data.media.id, tagId: quicksearch),
          searchCreateFormBuilder: (quicksearch) =>
              TagCreateForm(initialName: quicksearch),
          itemBuilder: (context, data) => TagMediaTileListItem(
            data: data,
            onTap: () =>
                go(context, path: CommonPaths.buildTagPath(data.tag.id)),
          ),
        ),
      ),
      TabDestination(
        icon: CommonIcons.devices,
        labelBuilder: (context) => context.localize().devicesTitle,
        onTap: (context) => _loadOnlyInitial<DevicePlayedGameListBloc>(context),
        child: RelationListBuilder<DeviceDTO, DevicePlayedGameListBloc>(
          itemBuilder: (context, data) => DeviceTileListItem(
            data: data,
            onTap: () =>
                go(context, path: CommonPaths.buildDevicePath(data.id)),
          ),
        ),
      ),
    ]);

    return MultiBlocListener(
      listeners: [
        BlocListener<UserGameDeleteBloc, ActionState<void>>(
          listener: (context, state) {
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
          listener: (context, state) {
            if (state is ActionInProgress<void>) {
              showSnackBar(
                context,
                message: context.localize().syncInProgressLabel,
              );
            }
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
          listener: (context, state) {
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
          if (!fromPage)
            ActionDestination(
              icon: CommonIcons.view,
              labelBuilder: (context) => context.localize().viewLabel,
              onTap: (context) =>
                  go(context, path: CommonPaths.buildGamePath(data.media.id)),
            ),
          ActionDestination(
            icon: CommonIcons.reload,
            labelBuilder: (context) => context.localize().reloadLabel,
            onTap: (context) => onEditSucceeded(context),
          ),
          ActionDestination(
            icon: CommonIcons.calendar,
            labelBuilder: (context) => context.localize().calendarLabel,
            onTap: (context) => go(
              context,
              path: CommonPaths.buildGameCalendarPath(data.media.id),
            ),
          ),
          ActionDestination(
            icon: CommonIcons.edit,
            labelBuilder: (context) => context.localize().editLabel,
            onTap: (context) async => showReturningDialog(
              context,
              builder: (context) => UserGameEditForm(id: data.media.id),
              onSuccess: (context, _) => onEditSucceeded(context),
            ),
          ),
          ActionDestination(
            icon: CommonIcons.sync,
            labelBuilder: (context) => context.localize().syncLabel,
            onTap: (context) =>
                context.read<UserGameSyncBloc>().add(ActionStarted(data: data)),
          ),
          ActionDestination(
            icon: CommonIcons.unsync,
            labelBuilder: (context) => context.localize().unsyncLabel,
            onTap: (context) => context.read<UserGameUnsyncBloc>().add(
              ActionStarted(data: data),
            ),
          ),
          ActionDestination(
            icon: CommonIcons.delete,
            labelBuilder: (context) => context.localize().deleteLabel,
            onTap: (context) async => showConfirmationDialog(
              context,
              builder: (context) => ConfirmationDialog(
                title: context.localize().deleteDialogTitle,
                subtitle: context.localize().deleteDialogSubtitle,
                message: context.localize().deleteDialogDataTitle(
                  data.media.title,
                ),
                acceptLabel: MaterialLocalizations.of(context)
                    .deleteButtonTooltip,
              ),
              onSuccess: (context) {
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

  Widget _info(BuildContext context) {
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
            skeletonBuilder: (context) => LabelSkeleton(
              order: 0,
              icon: CommonIcons.time,
              label: context.localize().totalTimeLabel,
            ),
            errorBuilder: (context, onRetryTap) => Center(
              child: LabelError(
                label: context.localize().errorTotalTimeLoadTitle,
                onRetryTap: onRetryTap,
              ),
            ),
            builder: (context, data) => DurationLabel(
              icon: CommonIcons.time,
              label: context.localize().totalTimeLabel,
              value: data,
            ),
          ),
          GetBuilder<List<SessionDTO>, UserGameFinishesGetBloc>(
            skeletonBuilder: (context) => LabelSkeleton(
              order: 1,
              icon: CommonIcons.finished,
              label: context.localize().finishedLabel,
            ),
            errorBuilder: (context, onRetryTap) => Center(
              child: LabelError(
                label: context.localize().errorFinishesLoadTitle,
                onRetryTap: onRetryTap,
              ),
            ),
            builder: (context, data) => TextLabel(
              icon: CommonIcons.finished,
              label: context.localize().finishedLabel,
              value: data.isEmpty
                  ? null
                  : MaterialLocalizations.of(context)
                            .formatCompactDate(data.first.startDatetime) +
                        (data.length > 1 ? '(+)' : ''),
            ),
          ),
        ],
      ),
    );
  }

  void _loadOnlyInitial<LB extends ListLoadBloc>(BuildContext context) {
    final lb = context.read<LB>();
    if (lb.state is ListInitial) {
      lb.add(ListSearchChanged(search: ListSearchDTO()));
    }
  }
}
