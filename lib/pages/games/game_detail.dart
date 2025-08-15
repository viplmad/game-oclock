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
        BlocProvider(
          create:
              (_) =>
                  UserGameAvailableListBloc()..add(
                    ListLoaded(
                      search: ListSearch(
                        name: 'default',
                        search: SearchDTO(),
                      ), // TODO unify selected index tab load
                    ),
                  ),
        ),
        BlocProvider(create: (_) => UserGameTagListBloc()),
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

              return Detail(
                title: data.title,
                imageUrl: data.coverUrl,
                onBackPressed:
                    () => GoRouter.of(context).go(CommonPaths.gamesPath),
                onEditPressed:
                    () async => showDialog<bool>(
                      context: context,
                      builder: (final context) => UserGameEditForm(id: data.id),
                    ).then((final bool? success) {
                      if (success != null && success && context.mounted) {
                        context.read<UserGameGetBloc>().add(
                          const ActionRestarted(),
                        );
                      }
                    }),
                content: Column(
                  children: [
                    Flexible(flex: 3, child: Column(children: [Text(data.id)])),
                    Flexible(
                      flex: 2,
                      child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              onTap:
                                  (final value) =>
                                      loadRelationList(context, value),
                              tabs: const [
                                Tab(
                                  icon: Icon(CommonIcons.locations),
                                  text: 'Locations',
                                ),
                                Tab(icon: Icon(CommonIcons.tags), text: 'Tags'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  GridListBuilder<
                                    GameAvailable,
                                    UserGameAvailableListBloc
                                  >(
                                    space: '', // TODO ?
                                    itemBuilder:
                                        (
                                          final context,
                                          final data,
                                          final index,
                                        ) => ListItemTile(title: data.name),
                                  ),
                                  GridListBuilder<Tag, UserGameTagListBloc>(
                                    space: '', // TODO ?
                                    itemBuilder:
                                        (
                                          final context,
                                          final data,
                                          final index,
                                        ) => ListItemTile(title: data.name),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void loadRelationList(final BuildContext context, final int index) {
    if (index == 0) {
      loadOnlyInitial<UserGameAvailableListBloc>(context);
    } else if (index == 1) {
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
}
