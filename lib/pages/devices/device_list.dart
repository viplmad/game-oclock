import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        DeviceDeleteBloc,
        DeviceListBloc,
        DeviceSelectBloc,
        ListReloaded,
        ListSearchGetBloc,
        ListSearchSaveBloc,
        ListStyleGetBloc,
        ListStyleSaveBloc,
        UserGamePlayedOnDeviceListBloc;
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/models/models.dart' show Device, ListStyle;
import 'package:game_oclock/shared/forms/device_form.dart';
import 'package:game_oclock/shared/list_item/device_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'device_detail.dart';

const String _space = 'device';

class DeviceListPage extends StatelessWidget {
  const DeviceListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DeviceSelectBloc()),
        BlocProvider(
          create: (_) =>
              DeviceListBloc(service: RepositoryProvider.of(context)),
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
              DeviceDeleteBloc(service: RepositoryProvider.of(context)),
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
      child: const _DeviceListDetailBuilder(),
    );
  }
}

class _DeviceListDetailBuilder extends StatelessWidget {
  const _DeviceListDetailBuilder();

  @override
  Widget build(final BuildContext context) {
    return ListCreateDetailBuilder<Device, DeviceSelectBloc, DeviceListBloc>(
      title: context.localize().devicesTitle,
      searchSpace: _space,
      createFormBuilder: ([final quicksearch]) =>
          DeviceCreateForm(initialName: quicksearch),
      detailBuilder: (final context, final data, final onClosed) {
        return MultiBlocProvider(
          // Recreate on selection change
          key: Key(data.id),
          providers: [
            BlocProvider(
              create: (_) => UserGamePlayedOnDeviceListBloc(
                service: RepositoryProvider.of(context),
                deviceId: data.id,
              ),
            ),
          ],
          child: DeviceDetail(
            data: data,
            extended: false,
            onBackPressed: onClosed,
            onEditSucceeded: (final context) {
              context.read<DeviceListBloc>().add(const ListReloaded());
            },
            onDeleteSucceeded: (final context) {
              context.read<DeviceListBloc>().add(const ListReloaded());
              context.read<DeviceSelectBloc>().add(
                const ActionStarted(data: null),
              );
            },
          ),
        );
      },
      listItemBuilder: (final context, final style, final data, final onTap) =>
          style == ListStyle.grid
          ? DeviceGridListItem(data: data, onTap: onTap)
          : DeviceTileListItem(data: data, onTap: onTap),
      itemAspectRatio: 1, // Square aspect ratio
    );
  }
}
