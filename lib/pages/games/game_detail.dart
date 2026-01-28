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
        UserGameGetBloc;
import 'package:game_oclock/components/cached_image.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list_detail.dart'
    show RelationListBuilder;
import 'package:game_oclock/constants/colors.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show
        Device,
        LayoutTier,
        LocationWithDate,
        SearchDTO,
        TabDestination,
        Tag,
        UserGame,
        gameStatusOptions;
import 'package:game_oclock/shared/forms/game_available_form.dart';
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/forms/game_tag_form.dart';
import 'package:game_oclock/shared/forms/location_form.dart';
import 'package:game_oclock/shared/forms/tag_form.dart';
import 'package:game_oclock/shared/list_item/device_list_item.dart';
import 'package:game_oclock/shared/list_item/game_available_list_item.dart';
import 'package:game_oclock/shared/list_item/tag_list_item.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
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
              UserGameDeleteBloc(service: RepositoryProvider.of(context)),
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
      child: DetailBuilder<UserGame, UserGameGetBloc>(
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

  final UserGame data;
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
        child: RelationListBuilder<LocationWithDate, LocationAvailableListBloc>(
          createFormBuilder: ([final quicksearch]) =>
              GameAvailableCreateForm(gameId: data.id, locationId: quicksearch),
          searchCreateFormBuilder: (final quicksearch) =>
              LocationCreateForm(initialName: quicksearch),
          itemBuilder: (final context, final data) =>
              LocationWithDateTileListItem(
                data: data,
                onTap: () => GoRouter.of(
                  context,
                ).go(CommonPaths.buildLocationPath(data.id)),
              ),
        ),
      ),
      TabDestination(
        icon: CommonIcons.tags,
        labelBuilder: (final context) => context.localize().tagsTitle,
        onTap: (final context) => _loadOnlyInitial<TagOfGameListBloc>(context),
        child: RelationListBuilder<Tag, TagOfGameListBloc>(
          createFormBuilder: ([final quicksearch]) =>
              GameTagCreateForm(gameId: data.id, tagId: quicksearch),
          searchCreateFormBuilder: (final quicksearch) =>
              TagCreateForm(initialName: quicksearch),
          itemBuilder: (final context, final data) => TagTileListItem(
            data: data,
            onTap: () =>
                GoRouter.of(context).go(CommonPaths.buildTagPath(data.id)),
          ),
        ),
      ),
      TabDestination(
        icon: CommonIcons.devices,
        labelBuilder: (final context) => context.localize().devicesTitle,
        onTap: (final context) =>
            _loadOnlyInitial<DevicePlayedGameListBloc>(context),
        child: RelationListBuilder<Device, DevicePlayedGameListBloc>(
          itemBuilder: (final context, final data) => DeviceTileListItem(
            data: data,
            onTap: () =>
                GoRouter.of(context).go(CommonPaths.buildDevicePath(data.id)),
          ),
        ),
      ),
    ]);

    return BlocListener<UserGameDeleteBloc, ActionState<void>>(
      listener: (final context, final state) {
        if (state is ActionSuccess<void, UserGame>) {
          showSnackBar(
            context,
            message: context.localize().deletedSuccessfullyLabel,
          );
          onDeleteSucceeded(context);
        }
        if (state is ActionFailure<void, UserGame>) {
          showErrorSnackBar(
            context,
            name: context.localize().unableToDeleteLabel,
            error: state.error,
          );
        }
      },
      child: DetailWithTabs(
        title: Text(data.title),
        image: SimpleCachedNetworkImage(
          imageUrl: data.imageUrl,
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
            ).go(CommonPaths.buildGameCalendarPath(data.id)),
          ),
          if (!fromPage)
            IconButton(
              icon: CommonIcons.view,
              tooltip: context.localize().viewLabel,
              onPressed: () =>
                  GoRouter.of(context).go(CommonPaths.buildGamePath(data.id)),
            ),
          IconButton(
            icon: CommonIcons.edit,
            tooltip: context.localize().editLabel,
            onPressed: () async => showFormDialog<UserGame>(
              context,
              builder: (final context) => UserGameEditForm(id: data.id),
              onSuccess: (final context, _) => onEditSucceeded(context),
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
                message: context.localize().deleteDialogDataTitle(data.title),
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
          TextLabel(label: context.localize().idLabel, value: data.id),
          TextLabel(label: context.localize().titleLabel, value: data.title),
          TextLabel(
            label: context.localize().editionLabel,
            value: data.edition,
          ),
          DateLabel(
            label: context.localize().releaseDateLabel,
            value: data.releaseDate,
          ),
          ChoiceLabel(
            label: context.localize().statusLabel,
            value: data.status,
            options: gameStatusOptions,
          ),
          RatingLabel(
            label: context.localize().ratingLabel,
            value: data.rating,
            color: CommonColors.ratingColor,
          ),
          TextLabel(
            label: context.localize().notesLabel,
            value: data.notes,
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

  void _loadOnlyInitial<LB extends ListLoadBloc>(final BuildContext context) {
    final lb = context.read<LB>();
    if (lb.state is ListInitial) {
      lb.add(ListSearchChanged(search: SearchDTO()));
    }
  }
}
