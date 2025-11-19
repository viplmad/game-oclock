import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionStarted,
        CurrentUserGetBloc,
        MinimizedLayoutBloc,
        SavedLoginResponseGetBloc;
import 'package:game_oclock/components/main_layout.dart' show MainLayoutBuilder;
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart';
import 'package:game_oclock/pages/calendar/multi_calendar.dart';
import 'package:game_oclock/pages/calendar/single_calendar.dart';
import 'package:game_oclock/pages/destinations.dart'
    show mainDestinations, secondaryDestinations;
import 'package:game_oclock/pages/devices/device_detail.dart';
import 'package:game_oclock/pages/devices/device_list.dart';
import 'package:game_oclock/pages/games/game_detail.dart';
import 'package:game_oclock/pages/games/game_list.dart';
import 'package:game_oclock/pages/locations/location_detail.dart';
import 'package:game_oclock/pages/locations/location_list.dart';
import 'package:game_oclock/pages/login/login.dart';
import 'package:game_oclock/pages/review/review.dart';
import 'package:game_oclock/pages/settings/settings.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  initialLocation: CommonPaths.loginPath,
  redirect: _authGuardRedirect,
  routes: [
    GoRoute(
      path: CommonPaths.loginPath,
      builder: (final BuildContext context, final GoRouterState state) {
        return const LoginPage();
      },
    ),
    ShellRoute(
      builder: (final context, final state, final child) {
        return MainLayoutBuilder(
          selectedPath: state.uri.path,
          mainDestinations: mainDestinations,
          secondaryDestinations: secondaryDestinations,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: CommonPaths.gamesPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.gamePath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final String id = CommonPaths.getIdParameter(state);
            return UserGameDetailPage(id: id);
          },
        ),
        GoRoute(
          path: CommonPaths.gameCalendarPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final String id = CommonPaths.getIdParameter(state);
            return SingleCalendarPage(gameId: id);
          },
        ),

        GoRoute(
          path: CommonPaths.locationsPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const LocationListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.locationPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final String id = CommonPaths.getIdParameter(state);
            return LocationDetailPage(id: id);
          },
        ),

        GoRoute(
          path: CommonPaths.devicesPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const DeviceListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.devicePath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            final String id = CommonPaths.getIdParameter(state);
            return DeviceDetailPage(id: id);
          },
        ),

        GoRoute(
          path: CommonPaths.tagsPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.usersPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.settingsPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const SettingsPage();
          },
        ),

        GoRoute(
          path: CommonPaths.calendarPath,
          builder: (final context, final state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const MultiCalendarPage();
          },
        ),

        GoRoute(
          path: CommonPaths.reviewPath,
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

FutureOr<String?> _authGuardRedirect(
  final BuildContext context,
  final GoRouterState state,
) async {
  final savedLoginBloc = context.read<SavedLoginResponseGetBloc>();
  final currentUserBloc = context.read<CurrentUserGetBloc>();

  savedLoginBloc.add(ActionStarted.empty());
  final savedLoginState =
      await savedLoginBloc.stream.firstWhere(
            (final actionState) =>
                actionState is ActionFinal<SavedLoginResponse, void>,
          )
          as ActionFinal<SavedLoginResponse, void>;
  if (savedLoginState is ActionFailure<SavedLoginResponse, void>) {
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
            .gamesPath // TODO redirectUrl pathparam
      : null;
}
