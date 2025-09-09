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
import 'package:game_oclock/components/list/list_item.dart'
    show GridListItem, TileListItem;
import 'package:game_oclock/components/list_detail.dart' show ListDetailBuilder;
import 'package:game_oclock/models/models.dart'
    show ListSearch, ListStyle, SearchDTO, UserGame;
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
          create: (_) => UserGameListBloc()
            ..add(
              ListLoaded(
                search: ListSearch(name: 'default', search: SearchDTO()),
              ),
            ),
        ),
        BlocProvider(create: (_) => UserGameDeleteBloc()),
        BlocProvider(
          create: (_) => ListStyleBloc()
            ..add(
              const ActionStarted(
                data: ListStyle.grid,
              ), // TODO get from localstorage
            ),
        ),
      ],
      child: ListDetailBuilder<UserGame, UserGameSelectBloc, UserGameListBloc>(
        title: context.localize().gamesTitle,
        searchSpace: 'game',
        detailBuilder: (final context, final data, final onClosed) {
          return MultiBlocProvider(
            // Recreate on selection change
            key: Key(data.id),
            providers: [
              BlocProvider(
                create: (_) => UserGameAvailableListBloc(gameId: data.id),
              ),
              BlocProvider(create: (_) => UserGameTagListBloc(gameId: data.id)),
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
        listItemBuilder:
            (final context, final style, final data, final onPressed) =>
                style == ListStyle.grid
                ? GridListItem(
                    title: data.edition.isEmpty
                        ? data.title
                        : context.localize().gameEditionDataTitle(
                            data.title,
                            data.edition,
                          ),
                    onTap: onPressed,
                  )
                : TileListItem(
                    title: data.edition.isEmpty
                        ? data.title
                        : context.localize().gameEditionDataTitle(
                            data.title,
                            data.edition,
                          ),
                    onTap: onPressed,
                  ),
      ),
    );
  }
}
