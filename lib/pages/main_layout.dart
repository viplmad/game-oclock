import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionState, ActionSuccess, CurrentUserGetBloc;
import 'package:game_oclock/components/main_layout.dart';
import 'package:game_oclock/models/models.dart' show NavDestination, User;
import 'package:game_oclock/pages/destinations.dart'
    show mainDestinations, secondaryDestinations, trailingDestinations;

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
    return BlocBuilder<CurrentUserGetBloc, ActionState<User>>(
      builder: (final context, final currentUserState) {
        final user = (currentUserState is ActionSuccess<User, void>)
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
    final User? user,
  ) {
    return user == null
        ? destinations
        : destinations
              .where((final dest) {
                final guardRole = dest.guardRole;
                return guardRole != null
                    ? user.roles.contains(dest.guardRole)
                    : true;
              })
              .toList(growable: false);
  }
}
