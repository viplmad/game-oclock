import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CurrentListSearchGetBloc,
        CurrentListSearchSaveBloc,
        CurrentListStyleGetBloc,
        CurrentListStyleSaveBloc,
        DevicePlayedGameListBloc,
        GameChildrenListBloc,
        ListReloaded,
        LocationAvailableListBloc,
        TagOfGameListBloc,
        UserGameDeleteBloc,
        UserGameFinishesGetBloc,
        UserGameListBloc,
        UserGameParentGetBloc,
        UserGameSelectBloc,
        UserGameSyncBloc,
        UserGameTotalTimeGetBloc,
        UserGameUnsyncBloc;
import 'package:game_oclock/components/list_detail.dart'
    show ListCreateDetailBuilder;
import 'package:game_oclock/constants/spaces.dart';
import 'package:game_oclock/models/models.dart' show ListStyle;
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

import 'game_detail.dart';

const String _space = CommonSpaces.game;

class UserGameListPage extends StatelessWidget {
  const UserGameListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserGameSelectBloc()),
        BlocProvider(
          create: (_) =>
              UserGameListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => CurrentListSearchGetBloc(
            service: RepositoryProvider.of(context),
            space: _space,
            defaultId: 'main',
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => CurrentListSearchSaveBloc(
            service: RepositoryProvider.of(context),
            space: _space,
          ),
        ),
        BlocProvider(
          create: (_) =>
              UserGameTotalTimeGetBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameFinishesGetBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameSyncBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) =>
              UserGameUnsyncBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => CurrentListStyleGetBloc(
            service: RepositoryProvider.of(context),
            space: _space,
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => CurrentListStyleSaveBloc(
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
  Widget build(BuildContext context) {
    return ListCreateDetailBuilder<
      MediaDTO,
      UserGameSelectBloc,
      UserGameListBloc
    >(
      title: context.localize().gamesTitle,
      searchSpace: _space,
      createFormBuilder: ([quicksearch]) =>
          UserGameCreateForm(initialTitle: quicksearch),
      idGetter: (data) => data.media.id,
      detailBuilder: (context, data, onClosed) {
        // Load derived blocs
        context.read<UserGameTotalTimeGetBloc>().add(
          ActionStarted(data: data.media.id),
        );
        context.read<UserGameFinishesGetBloc>().add(
          ActionStarted(data: data.media.id),
        );

        return MultiBlocProvider(
          // Recreate on selection change
          key: Key(data.media.id),
          providers: [
            BlocProvider(
              create: (_) => UserGameParentGetBloc(
                service: RepositoryProvider.of(context),
              ),
            ),
            BlocProvider(
              create: (_) => GameChildrenListBloc(
                service: RepositoryProvider.of(context),
                gameId: data.media.id,
              ),
            ),
            BlocProvider(
              create: (_) => LocationAvailableListBloc(
                service: RepositoryProvider.of(context),
                gameId: data.media.id,
              ),
            ),
            BlocProvider(
              create: (_) => TagOfGameListBloc(
                service: RepositoryProvider.of(context),
                gameId: data.media.id,
              ),
            ),
            BlocProvider(
              create: (_) => DevicePlayedGameListBloc(
                service: RepositoryProvider.of(context),
                gameId: data.media.id,
              ),
            ),
          ],
          child: UserGameDetail(
            data: data,
            extended: false,
            onBackPressed: onClosed,
            onEditSucceeded: (context) {
              context.read<UserGameListBloc>().add(const ListReloaded());
            },
            onDeleteSucceeded: (context) {
              context.read<UserGameListBloc>().add(const ListReloaded());
              context.read<UserGameSelectBloc>().add(
                const ActionStarted(data: null),
              );
            },
          ),
        );
      },
      listItemBuilder: (context, style, data, onTap) => style == ListStyle.grid
          ? UserGameGridListItem(data: data, onTap: onTap)
          : UserGameTileListItem(
              data: data,
              onTap: onTap,
              onAddSessionSucceeded: (context) =>
                  context.read<UserGameListBloc>().add(const ListReloaded()),
            ),
      itemAspectRatio: 1.85, // Steam header aspect ratio
    );
  }
}
