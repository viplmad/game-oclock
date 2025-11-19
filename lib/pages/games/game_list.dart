import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        DevicePlayedGameListBloc,
        ListReloaded,
        ListSearchGetBloc,
        ListSearchSaveBloc,
        ListStyleGetBloc,
        ListStyleSaveBloc,
        LocationAvailableListBloc,
        TagOfGameListBloc,
        UserGameDeleteBloc,
        UserGameListBloc,
        UserGameSelectBloc;
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
            service: RepositoryProvider.of(context),
            space: _space,
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => ListSearchSaveBloc(
            service: RepositoryProvider.of(context),
            space: _space,
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => ListStyleGetBloc(
            service: RepositoryProvider.of(context),
            space: _space,
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => ListStyleSaveBloc(
            service: RepositoryProvider.of(context),
            space: _space,
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
                service: RepositoryProvider.of(context),
                gameId: data.id,
              ),
            ),
            BlocProvider(
              create: (_) => TagOfGameListBloc(
                service: RepositoryProvider.of(context),
                gameId: data.id,
              ),
            ),
            BlocProvider(
              create: (_) => DevicePlayedGameListBloc(
                service: RepositoryProvider.of(context),
                gameId: data.id,
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
