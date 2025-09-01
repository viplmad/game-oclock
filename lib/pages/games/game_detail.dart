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
        UserGameAvailableListBloc,
        UserGameDeleteBloc,
        UserGameGetBloc,
        UserGameTagListBloc;
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/error_detail.dart';
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/components/list/tile_list.dart'
    show TileListBuilder;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show
        GameAvailable,
        LayoutTier,
        ListSearch,
        SearchDTO,
        TabDestination,
        Tag,
        UserGame;
import 'package:game_oclock/pages/games/game_form.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
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
          create: (_) => UserGameGetBloc()..add(ActionStarted(data: id)),
        ),
        BlocProvider(create: (_) => UserGameDeleteBloc()),
        BlocProvider(create: (_) => UserGameAvailableListBloc(gameId: id)),
        BlocProvider(create: (_) => UserGameTagListBloc(gameId: id)),
      ],
      child: BlocBuilder<UserGameGetBloc, ActionState<UserGame>>(
        builder: (final context, final state) {
          UserGame data;
          if (state is ActionFinal<UserGame, String>) {
            if (state is ActionFailure<UserGame, String>) {
              return Center(
                child: DetailError(
                  title: 'Error - Tap to refresh',
                  onRetryTap:
                      () => context.read<UserGameGetBloc>().add(
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
            extended: layoutTier != LayoutTier.compact,
            onBackPressed: () => GoRouter.of(context).go(CommonPaths.gamesPath),
            onEditSucceeded:
                (final context) => context.read<UserGameGetBloc>().add(
                  const ActionRestarted(),
                ),
            onDeleteSucceeded:
                (final context) =>
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
    required this.extended,
    required this.onBackPressed,
    required this.onEditSucceeded,
    required this.onDeleteSucceeded,
  });

  final UserGame data;
  final VoidCallback onBackPressed;
  final bool extended;
  final ValueChanged<BuildContext> onEditSucceeded;
  final ValueChanged<BuildContext> onDeleteSucceeded;

  @override
  Widget build(final BuildContext context) {
    if (extended) {
      _loadOnlyInitial<UserGameAvailableListBloc>(context);
    }

    final List<TabDestination> destinations = List.unmodifiable([
      TabDestination(
        icon: const Icon(CommonIcons.detail),
        label: 'Detail',
        onTap: (_) {},
        child: _info(),
      ),
      TabDestination(
        icon: const Icon(CommonIcons.locations),
        label: 'Locations',
        onTap:
            (final context) =>
                _loadOnlyInitial<UserGameAvailableListBloc>(context),
        child: TileListBuilder<GameAvailable, UserGameAvailableListBloc>(
          space: '', // TODO ?
          itemBuilder:
              (final context, final data, final index) =>
                  TileListItem(title: data.name),
        ),
      ),
      TabDestination(
        icon: const Icon(CommonIcons.tags),
        label: 'Tags',
        onTap:
            (final context) => _loadOnlyInitial<UserGameTagListBloc>(context),
        child: TileListBuilder<Tag, UserGameTagListBloc>(
          space: '', // TODO ?
          itemBuilder:
              (final context, final data, final index) =>
                  TileListItem(title: data.name),
        ),
      ),
    ]);

    return Detail(
      title: data.title,
      imageUrl: data.coverUrl,
      onBackPressed: onBackPressed,
      actions: [
        extended
            ? Container()
            : IconButton(
              // TODO hide if coming from detail
              icon: const Icon(CommonIcons.view),
              tooltip: 'View',
              onPressed: () => GoRouter.of(context).go('/games/${data.id}'),
            ),
        IconButton(
          icon: const Icon(CommonIcons.edit),
          tooltip: 'Edit',
          onPressed:
              () async => showDialog<bool>(
                context: context,
                builder: (final context) => UserGameEditForm(id: data.id),
              ).then((final bool? success) {
                if (success != null && success && context.mounted) {
                  onEditSucceeded(context);
                }
              }),
        ),
        IconButton(
          icon: const Icon(CommonIcons.delete),
          tooltip: 'Delete',
          onPressed: () async {
            return showDialog<bool>(
              context: context,
              builder: (final context) => _confirmDelete(context, data),
            ).then((final bool? success) {
              if (success != null && success && context.mounted) {
                context.read<UserGameDeleteBloc>().add(
                  ActionStarted(data: data),
                );
                onDeleteSucceeded(context); // TODO listen to bloc + snackbar
              }
            });
          },
        ),
      ],
      child:
          extended
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 2, child: _info()),
                  const VerticalDivider(width: 1.0),
                  Expanded(
                    flex: 4,
                    child: _tabs(
                      context,
                      destinations: destinations.sublist(1),
                    ),
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
            onTap:
                (final index) => destinations.elementAt(index).onTap(context),
            tabs: destinations
                .map((final dest) => Tab(icon: dest.icon, text: dest.label))
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
        ListLoaded(search: ListSearch(name: 'default', search: SearchDTO())),
      );
    }
  }

  Widget _confirmDelete(final BuildContext context, final UserGame data) {
    return AlertDialog(
      title: const Text(
        'Delete?',
      ), // TODO HeaderText(AppLocalizations.of(context)!.deleteString),
      content: ListTile(
        title: Text('${data.title} will be deleted.'), // TODO i18n
        subtitle: const Text('This action cannot be undone.'), // TODO i18n
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
