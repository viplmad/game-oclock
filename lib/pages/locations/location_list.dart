import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ListLoaded,
        ListReloaded,
        ListStyleBloc,
        LocationDeleteBloc,
        LocationListBloc,
        LocationSelectBloc,
        UserGameAvailableListBloc;
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/models/models.dart'
    show ListSearch, ListStyle, Location, SearchDTO;
import 'package:game_oclock/pages/locations/location_detail.dart'
    show LocationDetail;
import 'package:game_oclock/shared/forms/location_form.dart';
import 'package:game_oclock/shared/list_item/location_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class LocationListPage extends StatelessWidget {
  const LocationListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocationSelectBloc()),
        BlocProvider(
          create: (_) =>
              LocationListBloc(service: RepositoryProvider.of(context))..add(
                ListLoaded(
                  search: ListSearch(name: 'default', search: SearchDTO()),
                ),
              ),
        ),
        BlocProvider(
          create: (_) =>
              LocationDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => ListStyleBloc()
            ..add(
              const ActionStarted(
                data: ListStyle.grid,
              ), // TODO get from localstorage
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
      Location,
      LocationSelectBloc,
      LocationListBloc
    >(
      title: context.localize().locationsTitle,
      searchSpace: 'location',
      createFormBuilder: ([final quicksearch]) =>
          LocationCreateForm(initialName: quicksearch),
      detailBuilder: (final context, final data, final onClosed) {
        return MultiBlocProvider(
          // Recreate on selection change
          key: Key(data.id),
          providers: [
            BlocProvider(
              create: (_) => UserGameAvailableListBloc(
                locationId: data.id,
                service: RepositoryProvider.of(context),
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
