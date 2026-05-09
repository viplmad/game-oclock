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
        LocationDeleteBloc,
        LocationListBloc,
        LocationSelectBloc,
        UserGameAvailableListBloc;
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/constants/spaces.dart';
import 'package:game_oclock/models/models.dart' show ListStyle;
import 'package:game_oclock/shared/forms/location_form.dart';
import 'package:game_oclock/shared/list_item/location_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

import 'location_detail.dart';

const String _space = CommonSpaces.location;

class LocationListPage extends StatelessWidget {
  const LocationListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocationSelectBloc()),
        BlocProvider(
          create: (_) =>
              LocationListBloc(service: RepositoryProvider.of(context)),
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
              LocationDeleteBloc(service: RepositoryProvider.of(context)),
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
      child: const _LocationListDetailBuilder(),
    );
  }
}

class _LocationListDetailBuilder extends StatelessWidget {
  const _LocationListDetailBuilder();

  @override
  Widget build(final BuildContext context) {
    return ListCreateDetailBuilder<
      LocationDTO,
      LocationSelectBloc,
      LocationListBloc
    >(
      title: context.localize().locationsTitle,
      searchSpace: _space,
      createFormBuilder: ([final quicksearch]) =>
          LocationCreateForm(initialName: quicksearch),
      detailBuilder: (final context, final data, final onClosed) {
        return MultiBlocProvider(
          // Recreate on selection change
          key: Key(data.id),
          providers: [
            BlocProvider(
              create: (_) => UserGameAvailableListBloc(
                service: RepositoryProvider.of(context),
                locationId: data.id,
              ),
            ),
          ],
          child: LocationDetail(
            data: data,
            extended: false,
            onBackPressed: onClosed,
            onEditSucceeded: (final context) {
              context.read<LocationListBloc>().add(const ListReloaded());
            },
            onDeleteSucceeded: (final context) {
              context.read<LocationListBloc>().add(const ListReloaded());
              context.read<LocationSelectBloc>().add(
                const ActionStarted(data: null),
              );
            },
          ),
        );
      },
      listItemBuilder: (final context, final style, final data, final onTap) =>
          style == ListStyle.grid
          ? LocationGridListItem(data: data, onTap: onTap)
          : LocationTileListItem(data: data, onTap: onTap),
      itemAspectRatio: 1, // Square aspect ratio
    );
  }
}
