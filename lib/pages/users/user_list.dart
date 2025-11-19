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
        UserDeleteBloc,
        UserListBloc,
        UserSelectBloc;
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/models/models.dart' show ListStyle, User;
import 'package:game_oclock/shared/forms/user_form.dart';
import 'package:game_oclock/shared/list_item/user_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'user_detail.dart';

const String _space = 'user';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserSelectBloc()),
        BlocProvider(
          create: (_) => UserListBloc(service: RepositoryProvider.of(context)),
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
              UserDeleteBloc(service: RepositoryProvider.of(context)),
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
      child: const _UserListDetailBuilder(),
    );
  }
}

class _UserListDetailBuilder extends StatelessWidget {
  const _UserListDetailBuilder();

  @override
  Widget build(final BuildContext context) {
    return ListCreateDetailBuilder<User, UserSelectBloc, UserListBloc>(
      title: context.localize().usersTitle,
      searchSpace: _space,
      availableStyles: [ListStyle.tile],
      createFormBuilder: ([final quicksearch]) =>
          UserCreateForm(initialName: quicksearch),
      detailBuilder: (final context, final data, final onClosed) {
        return UserDetail(
          key: Key(data.id),
          data: data,
          extended: false,
          onBackPressed: onClosed,
          onEditSucceeded: (final context) {
            context.read<UserListBloc>().add(const ListReloaded());
          },
          onDeleteSucceeded: (final context) {
            context.read<UserListBloc>().add(const ListReloaded());
            context.read<UserSelectBloc>().add(const ActionStarted(data: null));
          },
        );
      },
      listItemBuilder: (final context, final style, final data, final onTap) =>
          UserTileListItem(data: data, onTap: onTap),
      itemAspectRatio: 1, // Square aspect ratio
    );
  }
}
