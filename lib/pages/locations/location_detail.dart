import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionRestarted,
        ActionStarted,
        LocationDeleteBloc,
        LocationGetBloc,
        UserGameAvailableListBloc;
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier, Location;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:go_router/go_router.dart';

class LocationDetailPage extends StatelessWidget {
  const LocationDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              LocationGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
        BlocProvider(
          create: (_) =>
              LocationDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => UserGameAvailableListBloc(
            locationId: id,
            service: RepositoryProvider.of(context),
          ),
        ),
      ],
      child: DetailBuilder<Location, LocationGetBloc>(
        onBackPressed: () => GoRouter.of(context).go(CommonPaths.locationsPath),
        builder: (final context, final data, final onBackPressed) =>
            LocationDetail(
              data: data,
              fromPage: true,
              extended: layoutTier != LayoutTier.compact,
              onBackPressed: onBackPressed,
              onEditSucceeded: (final context) =>
                  context.read<LocationGetBloc>().add(const ActionRestarted()),
              onDeleteSucceeded: (final context) =>
                  GoRouter.of(context).go(CommonPaths.locationsPath),
            ),
      ),
    );
  }
}

class LocationDetail extends StatelessWidget {
  const LocationDetail({
    super.key,
    required this.data,
    this.fromPage = false,
    required this.extended,
    required this.onBackPressed,
    required this.onEditSucceeded,
    required this.onDeleteSucceeded,
  });

  final Location data;
  final VoidCallback onBackPressed;
  final bool fromPage;
  final bool extended;
  final ValueChanged<BuildContext> onEditSucceeded;
  final ValueChanged<BuildContext> onDeleteSucceeded;

  @override
  Widget build(final BuildContext context) {
    return const SizedBox();
  }
}
