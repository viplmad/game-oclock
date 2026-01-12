import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionStarted,
        ActionSuccess,
        CurrentLoginResponseGetBloc,
        CurrentUserGetBloc,
        MinimizedLayoutBloc;
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart';
import 'package:game_oclock/pages/calendar/multi_calendar.dart';
import 'package:game_oclock/pages/calendar/single_calendar.dart';
import 'package:game_oclock/pages/destinations.dart';
import 'package:game_oclock/pages/devices/device_detail.dart';
import 'package:game_oclock/pages/devices/device_list.dart';
import 'package:game_oclock/pages/games/game_detail.dart';
import 'package:game_oclock/pages/games/game_list.dart';
import 'package:game_oclock/pages/locations/location_detail.dart';
import 'package:game_oclock/pages/locations/location_list.dart';
import 'package:game_oclock/pages/login/login.dart';
import 'package:game_oclock/pages/main_layout.dart';
import 'package:game_oclock/pages/playthroughs/playthrough_detail.dart';
import 'package:game_oclock/pages/playthroughs/playthrough_list.dart';
import 'package:game_oclock/pages/review/review.dart';
import 'package:game_oclock/pages/settings/settings.dart';
import 'package:game_oclock/pages/tags/tag_detail.dart';
import 'package:game_oclock/pages/tags/tag_list.dart';
import 'package:game_oclock/pages/users/user_detail.dart';
import 'package:game_oclock/pages/users/user_list.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  initialLocation: CommonPaths.loginPath,
  redirect: _authGuardRedirect,
  routes: [
    GoRoute(
      path: CommonPaths.loginPath,
      builder: (final context, final state) {
        return const LoginPage();
      },
    ),
    ShellRoute(
      builder: (final context, final state, final child) {
        return MainLayout(selectedPath: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: CommonPaths.gamesPath,
          redirect: _destinationGuardRedirect(gamesNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.gamePath,
          redirect: _destinationGuardRedirect(gamesNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final id = CommonPaths.getIdParameter(state);
            return UserGameDetailPage(id: id);
          },
        ),
        GoRoute(
          path: CommonPaths.gameCalendarPath,
          redirect: _destinationGuardRedirect(gamesNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final id = CommonPaths.getIdParameter(state);
            return SingleCalendarPage(gameId: id);
          },
        ),

        GoRoute(
          path: CommonPaths.locationsPath,
          redirect: _destinationGuardRedirect(locationsNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const LocationListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.locationPath,
          redirect: _destinationGuardRedirect(locationsNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final id = CommonPaths.getIdParameter(state);
            return LocationDetailPage(id: id);
          },
        ),

        GoRoute(
          path: CommonPaths.devicesPath,
          redirect: _destinationGuardRedirect(devicesNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const DeviceListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.devicePath,
          redirect: _destinationGuardRedirect(devicesNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final id = CommonPaths.getIdParameter(state);
            return DeviceDetailPage(id: id);
          },
        ),

        GoRoute(
          path: CommonPaths.tagsPath,
          redirect: _destinationGuardRedirect(tagsNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const TagListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.tagPath,
          redirect: _destinationGuardRedirect(tagsNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final id = CommonPaths.getIdParameter(state);
            return TagDetailPage(id: id);
          },
        ),

        GoRoute(
          path: CommonPaths.playthroughsPath,
          redirect: _destinationGuardRedirect(playthroughsNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const PlaythroughListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.playthroughPath,
          redirect: _destinationGuardRedirect(playthroughsNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final id = CommonPaths.getIdParameter(state);
            return PlaythroughDetailPage(id: id);
          },
        ),

        GoRoute(
          path: CommonPaths.usersPath,
          redirect: _destinationGuardRedirect(usersNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.userPath,
          redirect: _destinationGuardRedirect(usersNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final id = CommonPaths.getIdParameter(state);
            return UserDetailPage(id: id);
          },
        ),

        GoRoute(
          path: CommonPaths.settingsPath,
          redirect: _destinationGuardRedirect(settingsNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const SettingsPage();
          },
        ),

        GoRoute(
          path: CommonPaths.calendarPath,
          redirect: _destinationGuardRedirect(calendarNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const MultiCalendarPage();
          },
        ),

        GoRoute(
          path: CommonPaths.reviewPath,
          redirect: _destinationGuardRedirect(reviewNavDestination),
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const ReviewPage();
          },
        ),
      ],
    ),
  ],
);

GoRouterRedirect? _destinationGuardRedirect(final NavDestination destination) {
  final guardRole = destination.guardRole;
  return guardRole != null
      ? (final context, final state) =>
            _roleGuardRedirect(context, state, guardRole)
      : null;
}

FutureOr<String?> _authGuardRedirect(
  final BuildContext context,
  final GoRouterState state,
) async {
  final currentLoginResponseBloc = context.read<CurrentLoginResponseGetBloc>();
  final currentUserBloc = context.read<CurrentUserGetBloc>();

  currentLoginResponseBloc.add(ActionStarted.empty());
  final currentLoginResponseState =
      await currentLoginResponseBloc.stream.firstWhere(
            (final actionState) =>
                actionState is ActionFinal<SavedLoginResponse, void>,
          )
          as ActionFinal<SavedLoginResponse, void>;
  if (currentLoginResponseState is ActionFailure<SavedLoginResponse, void>) {
    return CommonPaths.loginPath;
  }

  currentUserBloc.add(ActionStarted.empty());
  final currentUserState =
      await currentUserBloc.stream.firstWhere(
            (final actionState) => actionState is ActionFinal<User, void>,
          )
          as ActionFinal<User, void>;
  if (currentUserState is ActionFailure<User, void>) {
    return CommonPaths.loginPath;
  }

  return state.uri.path == CommonPaths.loginPath
      ? CommonPaths
            .homePath // TODO redirectUrl pathparam
      : null;
}

FutureOr<String?> _roleGuardRedirect(
  final BuildContext context,
  final GoRouterState state,
  final String role,
) async {
  final currentUserBloc = context.read<CurrentUserGetBloc>();

  currentUserBloc.add(ActionStarted.empty());
  final currentUserState =
      await currentUserBloc.stream.firstWhere(
            (final actionState) => actionState is ActionFinal<User, void>,
          )
          as ActionFinal<User, void>;
  if (currentUserState is ActionFailure<User, void>) {
    return CommonPaths.loginPath;
  }

  return (currentUserState as ActionSuccess<User, void>).data.roles.contains(
        role,
      )
      ? null
      : CommonPaths.homePath;
}
