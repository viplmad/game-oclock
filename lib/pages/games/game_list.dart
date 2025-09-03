import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ListLoaded,
        ListReloaded,
        UserGameAvailableListBloc,
        UserGameDeleteBloc,
        UserGameListBloc,
        UserGameSelectBloc,
        UserGameTagListBloc;
import 'package:game_oclock/components/list/list_item.dart' show GridListItem;
import 'package:game_oclock/components/list_detail.dart' show ListDetailBuilder;
import 'package:game_oclock/models/models.dart'
    show ListSearch, SearchDTO, UserGame;

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
      ],
      child: ListDetailBuilder<UserGame, UserGameSelectBloc, UserGameListBloc>(
        title: 'Games', // TODO i18n
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
        listItemBuilder: (final context, final data, final onPressed) =>
            GridListItem(
              title:
                  '${data.title}${data.edition.isNotEmpty ? ' - ${data.edition}' : ''}',
              onTap: onPressed,
            ),
      ),
    );
  }
}
