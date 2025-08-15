import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ListLoaded,
        ListReloaded,
        UserGameAvailableListBloc,
        UserGameListBloc,
        UserGameSelectBloc,
        UserGameTagListBloc;
import 'package:game_oclock/components/list_detail.dart' show ListDetailBuilder;
import 'package:game_oclock/components/list_item.dart' show ListItemGrid;
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
          create:
              (_) =>
                  UserGameListBloc()..add(
                    ListLoaded(
                      search: ListSearch(name: 'default', search: SearchDTO()),
                    ),
                  ),
        ),
        BlocProvider(create: (_) => UserGameAvailableListBloc()), // TODO reload on selection change
        BlocProvider(create: (_) => UserGameTagListBloc()),
      ],
      child: ListDetailBuilder<UserGame, UserGameSelectBloc, UserGameListBloc>(
        title: 'Games', // TODO i18n
        searchSpace: 'game',
        detailBuilder:
            (final context, final data, final onClosed) => UserGameDetail(
              data: data,
              onBackPressed: onClosed,
              onEditSucceeded: (final context) {
                context.read<UserGameListBloc>().add(const ListReloaded());
              },
            ),
        listItemBuilder:
            (final context, final data, final onPressed) => ListItemGrid(
              title:
                  '${data.title}${data.edition.isNotEmpty ? ' - ${data.edition}' : ''}',
              onTap: onPressed,
            ),
      ),
    );
  }
}
