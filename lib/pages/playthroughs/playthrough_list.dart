import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CurrentListSearchGetBloc,
        CurrentListSearchSaveBloc,
        CurrentListStyleGetBloc,
        CurrentListStyleSaveBloc,
        ListReloaded,
        PlaythroughDeleteBloc,
        PlaythroughListBloc,
        PlaythroughSelectBloc,
        UserGameWithPlaythroughListBloc;
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/constants/spaces.dart';
import 'package:game_oclock/models/models.dart' show ListStyle, Playthrough;
import 'package:game_oclock/shared/forms/playthrough_form.dart';
import 'package:game_oclock/shared/list_item/playthrough_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'playthrough_detail.dart';

const String _space = CommonSpaces.playthrough;

class PlaythroughListPage extends StatelessWidget {
  const PlaythroughListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PlaythroughSelectBloc()),
        BlocProvider(
          create: (_) =>
              PlaythroughListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => CurrentListSearchGetBloc(
            service: RepositoryProvider.of(context),
            space: _space,
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
              PlaythroughDeleteBloc(service: RepositoryProvider.of(context)),
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
      child: const _PlaythroughListDetailBuilder(),
    );
  }
}

class _PlaythroughListDetailBuilder extends StatelessWidget {
  const _PlaythroughListDetailBuilder();

  @override
  Widget build(final BuildContext context) {
    return ListCreateDetailBuilder<
      Playthrough,
      PlaythroughSelectBloc,
      PlaythroughListBloc
    >(
      title: context.localize().playthroughsTitle,
      searchSpace: _space,
      availableStyles: [ListStyle.tile],
      createFormBuilder: ([final quicksearch]) =>
          PlaythroughCreateForm(initialName: quicksearch),
      detailBuilder: (final context, final data, final onClosed) {
        return MultiBlocProvider(
          // Recreate on selection change
          key: Key(data.id),
          providers: [
            BlocProvider(
              create: (_) => UserGameWithPlaythroughListBloc(
                service: RepositoryProvider.of(context),
                playthroughId: data.id,
              ),
            ),
          ],
          child: PlaythroughDetail(
            data: data,
            extended: false,
            onBackPressed: onClosed,
            onEditSucceeded: (final context) {
              context.read<PlaythroughListBloc>().add(const ListReloaded());
            },
            onDeleteSucceeded: (final context) {
              context.read<PlaythroughListBloc>().add(const ListReloaded());
              context.read<PlaythroughSelectBloc>().add(
                const ActionStarted(data: null),
              );
            },
          ),
        );
      },
      listItemBuilder: (final context, final style, final data, final onTap) =>
          PlaythroughTileListItem(data: data, onTap: onTap),
      itemAspectRatio: 1, // Square aspect ratio
    );
  }
}
