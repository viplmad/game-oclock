import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CurrentListSearchGetBloc,
        CurrentListSearchSaveBloc,
        CurrentListStyleGetBloc,
        CurrentListStyleSaveBloc,
        ExternalGameListBloc,
        ExternalGameSelectBloc,
        ListReloaded;
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/models/models.dart' show ListStyle;
import 'package:game_oclock/pages/search/external_game_detail.dart';
import 'package:game_oclock/shared/list_item/external_game_list_item.dart';
import 'package:game_oclock_client/api.dart';

const String _space = 'external';

class ExternalGameListPage extends StatelessWidget {
  const ExternalGameListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExternalGameSelectBloc()),
        BlocProvider(
          create: (_) =>
              ExternalGameListBloc(service: RepositoryProvider.of(context)),
        ),
        // TODO remove this providers
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
      child: const _ExternalGameListDetailBuilder(),
    );
  }
}

class _ExternalGameListDetailBuilder extends StatelessWidget {
  const _ExternalGameListDetailBuilder();

  @override
  Widget build(final BuildContext context) {
    return ListDetailBuilder<
      PotentialMediaDTO,
      ExternalGameSelectBloc,
      ExternalGameListBloc
    >(
      title: 'Search', // TODO
      searchSpace: _space,
      availableStyles: [ListStyle.tile],
      detailBuilder: (final context, final data, final onClosed) {
        return ExternalGameDetail(
          key: Key(data.external_.id),
          data: data,
          onBackPressed: onClosed,
          onAddSucceeded: (final context) =>
              context.read<ExternalGameListBloc>().add(
                const ListReloaded(), // TODO Only reload user info
              ),
        );
      },
      listItemBuilder: (final context, final style, final data, final onTap) =>
          ExternalGameTileListItem(
            data: data,
            onTap: onTap,
            onAddSucceeded: (final context) =>
                context.read<ExternalGameListBloc>().add(
                  const ListReloaded(), // TODO Only reload user info
                ),
          ),
      itemAspectRatio: 1.85, // Steam header aspect ratio
    );
  }
}
