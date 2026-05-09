import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionState, ActionSuccess, CurrentUserGetBloc;
import 'package:game_oclock/components/main_layout.dart';
import 'package:game_oclock/models/models.dart' show NavDestination;
import 'package:game_oclock/pages/destinations.dart'
    show mainDestinations, secondaryDestinations, trailingDestinations;
import 'package:game_oclock_client/api.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.selectedPath,
    required this.child,
  });

  final String selectedPath;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<CurrentUserGetBloc, ActionState<UserDTO>>(
      builder: (final context, final currentUserState) {
        final user = (currentUserState is ActionSuccess<UserDTO, void>)
            ? currentUserState.data
            : null;

        return MainLayoutBuilder(
          selectedPath: selectedPath,
          mainDestinations: _filterDestinationByUser(mainDestinations, user),
          secondaryDestinations: _filterDestinationByUser(
            secondaryDestinations,
            user,
          ),
          trailingDestinations: _filterDestinationByUser(
            trailingDestinations,
            user,
          ),
          child: child,
        );
      },
    );
  }

  List<NavDestination> _filterDestinationByUser(
    final List<NavDestination> destinations,
    final UserDTO? user,
  ) {
    return user == null
        ? destinations
        : destinations
              .where((final dest) => dest.guardRoles.contains(user.role))
              .toList(growable: false);
  }
}
