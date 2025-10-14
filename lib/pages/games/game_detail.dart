import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionInProgress,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ListInitial,
        ListLoadBloc,
        ListLoaded,
        ListReloaded,
        UserGameAvailableListBloc,
        UserGameDeleteBloc,
        UserGameGetBloc,
        UserGameTagListBloc;
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/error_detail.dart';
import 'package:game_oclock/components/list/list.dart';
import 'package:game_oclock/components/list/tile_list.dart'
    show TileListBuilder;
import 'package:game_oclock/components/show_form_dialog.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show
        LayoutTier,
        ListSearch,
        LocationWithDate,
        SearchDTO,
        TabDestination,
        Tag,
        UserGame;
import 'package:game_oclock/pages/games/game_available_form.dart';
import 'package:game_oclock/pages/games/game_form.dart';
import 'package:game_oclock/pages/games/game_tag_form.dart';
import 'package:game_oclock/shared/list_item/game_available_list_item.dart';
import 'package:game_oclock/shared/list_item/tag_list_item.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:go_router/go_router.dart';

class UserGameDetailsPage extends StatelessWidget {
  const UserGameDetailsPage({super.key, required this.id});

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
          create: (_) => UserGameAvailableListBloc(
            gameId: id,
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => UserGameTagListBloc(
            gameId: id,
            service: RepositoryProvider.of(context),
          ),
        ),
      ],
      child: BlocBuilder<UserGameGetBloc, ActionState<UserGame>>(
        builder: (final context, final state) {
          UserGame data;
          if (state is ActionFinal<UserGame, String>) {
            if (state is ActionFailure<UserGame, String>) {
              return Center(
                child: DetailError(
                  title: context.localize().errorDetailLoadTitle,
                  onRetryTap: () => context.read<UserGameGetBloc>().add(
                    const ActionRestarted(),
                  ),
                ),
              );
            }
            data = state.data;
          } else if (state is ActionInProgress<UserGame>) {
            if (state.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            data = state.data!;
          } else {
            return const Center(); // TODO
          }

          return UserGameDetail(
            data: data,
            fromPage: true,
            extended: layoutTier != LayoutTier.compact,
            onBackPressed: () => GoRouter.of(context).go(CommonPaths.gamesPath),
            onEditSucceeded: (final context) =>
                context.read<UserGameGetBloc>().add(const ActionRestarted()),
            onDeleteSucceeded: (final context) =>
                GoRouter.of(context).go(CommonPaths.gamesPath),
          );
        },
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
    if (extended) {
      _loadOnlyInitial<UserGameAvailableListBloc>(context);
    }

    final List<TabDestination>
    destinations = List.unmodifiable(<TabDestination>[
      TabDestination(
        icon: CommonIcons.detail,
        labelBuilder: (final context) => context.localize().detailLabel,
        onTap: (_) {},
        child: _info(),
      ),
      TabDestination(
        icon: CommonIcons.locations,
        labelBuilder: (final context) => context.localize().locationsTitle,
        onTap: (final context) =>
            _loadOnlyInitial<UserGameAvailableListBloc>(context),
        child: RelationListBuilder<LocationWithDate, UserGameAvailableListBloc>(
          label: context.localize().locationLabel,
          createFormBuilder: () =>
              GameAvailableCreateForm.fixedGame(gameId: data.id),
          itemBuilder: (final data) => GameAvailableTileListItem(data: data),
        ),
      ),
      TabDestination(
        icon: CommonIcons.tags,
        labelBuilder: (final context) => context.localize().tagsTitle,
        onTap: (final context) =>
            _loadOnlyInitial<UserGameTagListBloc>(context),
        child: RelationListBuilder<Tag, UserGameTagListBloc>(
          label: context.localize().tagLabel,
          createFormBuilder: () => GameTagCreateForm.fixedGame(gameId: data.id),
          itemBuilder: (final data) => TagTileListItem(data: data),
        ),
      ),
    ]);

    return Detail(
      title: data.title,
      imageUrl: data.coverUrl,
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
          onPressed: () async => showFormDialog(
            context,
            builder: (final context) => UserGameEditForm(id: data.id),
            onSuccess: onEditSucceeded,
          ),
        ),
        IconButton(
          icon: CommonIcons.delete,
          tooltip: context.localize().deleteLabel,
          onPressed: () async => showFormDialog(
            context,
            builder: (final context) => _confirmDelete(context, data),
            onSuccess: (final context) {
              context.read<UserGameDeleteBloc>().add(ActionStarted(data: data));
              onDeleteSucceeded(context); // TODO listen to bloc + snackbar
            },
          ),
        ),
      ],
      child: extended
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: _info()),
                const VerticalDivider(width: 1.0),
                Expanded(
                  flex: 4,
                  child: _tabs(context, destinations: destinations.sublist(1)),
                ),
              ],
            )
          : _tabs(context, destinations: destinations),
    );
  }

  Widget _info() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
      child: Column(children: [Text(data.id)]), // TODO
    );
  }

  Widget _tabs(
    final BuildContext context, {
    required final List<TabDestination> destinations,
  }) {
    return DefaultTabController(
      length: destinations.length,
      child: Column(
        children: [
          TabBar(
            onTap: (final index) =>
                destinations.elementAt(index).onTap(context),
            tabs: destinations
                .map(
                  (final dest) =>
                      Tab(icon: dest.icon, text: dest.labelBuilder(context)),
                )
                .toList(growable: false),
          ),
          Expanded(
            child: TabBarView(
              children: destinations
                  .map((final dest) => dest.child)
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }

  void _loadOnlyInitial<LB extends ListLoadBloc>(final BuildContext context) {
    final lb = context.read<LB>();
    if (lb.state is ListInitial) {
      lb.add(
        ListLoaded(
          search: ListSearch(name: 'default', search: SearchDTO()),
        ),
      );
    }
  }

  Widget _confirmDelete(final BuildContext context, final UserGame data) {
    return AlertDialog(
      title: Text(
        context.localize().deleteDialogTitle,
      ), // TODO HeaderText(AppLocalizations.of(context)!.deleteString),
      content: ListTile(
        title: Text(context.localize().deleteDialogDataTitle(data.title)),
        subtitle: Text(context.localize().deleteDialogSubtitle),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () async => await Navigator.maybePop(context),
        ),
        TextButton(
          onPressed: () async => await Navigator.maybePop(context, true),
          child: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
        ),
      ],
    );
  }
}

class RelationListBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  // TODO filtering?
  const RelationListBuilder({
    super.key,
    required this.label,
    required this.createFormBuilder,
    required this.itemBuilder,
  });

  final String label;
  final Widget Function() createFormBuilder;
  final Widget Function(T data) itemBuilder;

  @override
  Widget build(final BuildContext context) {
    return ListToolbar(
      toolbars: [
        ListButtonToolbar(
          label: context.localize().linkDataLabel(label),
          icon: CommonIcons.link,
          onTap: () async => showFormDialog(
            context,
            builder: (final context) => createFormBuilder(),
            onSuccess: (final context) =>
                context.read<LB>().add(const ListReloaded()),
          ),
        ),
      ],
      child: TileListBuilder<T, LB>(
        itemBuilder: (final context, final data, final index) =>
            itemBuilder(data),
      ),
    );
  }
}
