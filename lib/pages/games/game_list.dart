import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ListReloaded,
        ListSearchGetBloc,
        ListSearchSaveBloc,
        ListStyleGetBloc,
        ListStyleSaveBloc,
        LocationAvailableListBloc,
        UserGameDeleteBloc,
        UserGameListBloc,
        UserGameSelectBloc,
        UserGameTagListBloc;
import 'package:game_oclock/components/list_detail.dart'
    show ListCreateDetailBuilder;
import 'package:game_oclock/models/models.dart' show ListStyle, UserGame;
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'game_detail.dart';

const String _space = 'game';

class UserGameListPage extends StatelessWidget {
  const UserGameListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserGameSelectBloc()),
        BlocProvider(
          create: (_) =>
              UserGameListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => ListSearchGetBloc(
            space: _space,
            service: RepositoryProvider.of(context),
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => ListSearchSaveBloc(
            space: _space,
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => ListStyleGetBloc(
            space: _space,
            service: RepositoryProvider.of(context),
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => ListStyleSaveBloc(
            space: _space,
            service: RepositoryProvider.of(context),
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
      searchSpace: _space,
      createFormBuilder: ([final quicksearch]) =>
          UserGameCreateForm(initialTitle: quicksearch),
      detailBuilder: (final context, final data, final onClosed) {
        return MultiBlocProvider(
          // Recreate on selection change
          key: Key(data.id),
          providers: [
            BlocProvider(
              create: (_) => LocationAvailableListBloc(
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
      itemAspectRatio: 1.85, // Steam header aspect ratio
    );
  }
}
