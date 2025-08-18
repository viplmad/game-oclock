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
        LayoutTierBloc,
        LayoutTierState,
        ListInitial,
        ListLoadBloc,
        ListLoaded,
        UserGameAvailableListBloc,
        UserGameDeleteBloc,
        UserGameGetBloc,
        UserGameTagListBloc;
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/error_detail.dart';
import 'package:game_oclock/components/grid_list.dart';
import 'package:game_oclock/components/list_item.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show GameAvailable, ListSearch, SearchDTO, Tag, UserGame;
import 'package:game_oclock/pages/games/game_form.dart';
import 'package:go_router/go_router.dart';

class UserGameDetailsPage extends StatelessWidget {
  const UserGameDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserGameGetBloc()..add(ActionStarted(data: id)),
        ),
        BlocProvider(create: (_) => UserGameDeleteBloc()),
        BlocProvider(create: (_) => UserGameAvailableListBloc(gameId: id)),
        BlocProvider(create: (_) => UserGameTagListBloc(gameId: id)),
      ],
      child: BlocBuilder<LayoutTierBloc, LayoutTierState>(
        builder: (final context, final layoutState) {
          final layoutTier = layoutState.tier;

          return BlocBuilder<UserGameGetBloc, ActionState<UserGame>>(
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
                onBackPressed:
                    () => GoRouter.of(context).go(CommonPaths.gamesPath),
                onEditSucceeded:
                    (final context) => context.read<UserGameGetBloc>().add(
                      const ActionRestarted(),
                    ),
                onDeleteSucceeded:
                    (final context) =>
                        GoRouter.of(context).go(CommonPaths.gamesPath),
              );
            },
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
    required this.onBackPressed,
    required this.onEditSucceeded,
    required this.onDeleteSucceeded,
  });

  final UserGame data;
  final VoidCallback onBackPressed;
  final void Function(BuildContext context) onEditSucceeded;
  final void Function(BuildContext context) onDeleteSucceeded;

  @override
  Widget build(final BuildContext context) {
    return Detail(
      title: data.title,
      imageUrl: data.coverUrl,
      onBackPressed: onBackPressed,
      actions: [
        IconButton(
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
              builder: (final context) => confirmDelete(context, data),
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
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              onTap: (final value) => loadRelationList(context, value),
              tabs: const [
                Tab(icon: Icon(CommonIcons.detail), text: 'Detail'),
                Tab(icon: Icon(CommonIcons.locations), text: 'Locations'),
                Tab(icon: Icon(CommonIcons.tags), text: 'Tags'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 24.0,
                      left: 24.0,
                      right: 24.0,
                    ),
                    child: Column(children: [Text(data.id)]), // TODO
                  ),
                  GridListBuilder<GameAvailable, UserGameAvailableListBloc>(
                    space: '', // TODO ?
                    itemBuilder:
                        (final context, final data, final index) =>
                            ListItemTile(title: data.name),
                  ),
                  GridListBuilder<Tag, UserGameTagListBloc>(
                    space: '', // TODO ?
                    itemBuilder:
                        (final context, final data, final index) =>
                            ListItemTile(title: data.name),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadRelationList(final BuildContext context, final int index) {
    if (index == 1) {
      // TODO constants
      loadOnlyInitial<UserGameAvailableListBloc>(context);
    } else if (index == 2) {
      loadOnlyInitial<UserGameTagListBloc>(context);
    }
  }

  void loadOnlyInitial<LB extends ListLoadBloc>(final BuildContext context) {
    final lb = context.read<LB>();
    if (lb.state is ListInitial) {
      lb.add(
        ListLoaded(search: ListSearch(name: 'default', search: SearchDTO())),
      );
    }
  }

  Widget confirmDelete(final BuildContext context, final UserGame data) {
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
