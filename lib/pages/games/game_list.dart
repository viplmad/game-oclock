import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ListLoaded,
        ListReloaded,
        ListStyleBloc,
        UserGameAvailableListBloc,
        UserGameDeleteBloc,
        UserGameListBloc,
        UserGameSelectBloc,
        UserGameTagListBloc;
import 'package:game_oclock/components/list_detail.dart'
    show ListCreateDetailBuilder;
import 'package:game_oclock/models/models.dart'
    show ListSearch, ListStyle, SearchDTO, UserGame;
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'game_detail.dart';

class UserGameListPage extends StatelessWidget {
  const UserGameListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserGameSelectBloc()),
        BlocProvider(
          create: (_) =>
              UserGameListBloc(service: RepositoryProvider.of(context))..add(
                ListLoaded(
                  search: ListSearch(name: 'default', search: SearchDTO()),
                ),
              ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => ListStyleBloc()
            ..add(
              const ActionStarted(
                data: ListStyle.grid,
              ), // TODO get from localstorage
            ),
        ),
      ],
      child: const _UserGameListDetailBuilder(),
    );
  }
}

class _UserGameListDetailBuilder extends StatelessWidget {
  const _UserGameListDetailBuilder();

  @override
  Widget build(final BuildContext context) {
    return ListCreateDetailBuilder<
      UserGame,
      UserGameSelectBloc,
      UserGameListBloc
    >(
      title: context.localize().gamesTitle,
      searchSpace: 'game',
      createFormBuilder: ([final quicksearch]) =>
          UserGameCreateForm(initialTitle: quicksearch),
      detailBuilder: (final context, final data, final onClosed) {
        return MultiBlocProvider(
          // Recreate on selection change
          key: Key(data.id),
          providers: [
            BlocProvider(
              create: (_) => UserGameAvailableListBloc(
                gameId: data.id,
                service: RepositoryProvider.of(context),
              ),
            ),
            BlocProvider(
              create: (_) => UserGameTagListBloc(
                gameId: data.id,
                service: RepositoryProvider.of(context),
              ),
            ),
          ],
          child: UserGameDetail(
            data: data,
            extended: false,
            onBackPressed: onClosed,
            onEditSucceeded: (final context) {
              context.read<UserGameListBloc>().add(const ListReloaded());
            },
            onDeleteSucceeded: (final context) {
              context.read<UserGameListBloc>().add(const ListReloaded());
              context.read<UserGameSelectBloc>().add(
                const ActionStarted(data: null),
              );
            },
          ),
        );
      },
      listItemBuilder: (final context, final style, final data, final onTap) =>
          style == ListStyle.grid
          ? UserGameGridListItem(data: data, onTap: onTap)
          : UserGameTileListItem(data: data, onTap: onTap),
    );
  }
}
