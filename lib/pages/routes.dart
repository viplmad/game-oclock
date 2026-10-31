import 'dart:async' show FutureOr;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionInitial,
        ActionStarted,
        ActionSuccess,
        ApiClientInitBloc,
        CurrentLoginResponseGetBloc,
        CurrentUserGetBloc,
        LogoutBloc,
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
import 'package:game_oclock/pages/search/external_game_list.dart';
import 'package:game_oclock/pages/settings/settings.dart';
import 'package:game_oclock/pages/tags/tag_detail.dart';
import 'package:game_oclock/pages/tags/tag_list.dart';
import 'package:game_oclock/pages/users/user_detail.dart';
import 'package:game_oclock/pages/users/user_list.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:game_oclock_client/api.dart';
import 'package:go_router/go_router.dart';

class PathHistory {
  final history = <String>[];
  bool ignoreNextPush = false;

  void push(String path) {
    if (ignoreNextPush) {
      return;
    }
    history.add(path);
  }

  String? pop() {
    if (history.isEmpty) {
      return null;
    }
    ignoreNextPush = true;
    return history.removeLast();
  }
}

class _HistoryNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      final path = _buildPath(previousRoute);
      if (path != null) {
        final PathHistory history = RepositoryProvider.of(
          route.navigator!.context,
        );
        history.push(path);
      }
    }

    super.didPush(route, previousRoute);
  }

  static String? _buildPath(Route<dynamic> route) {
    String? path = route.settings.name;
    final args = route.settings.arguments;
    if (path != null && args is Map<String, String>) {
      for (final entry in args.entries) {
        path = path!.replaceAll(':${entry.key}', entry.value);
      }
    }
    return path;
  }
}

// GoRouter configuration
final routerConfig = GoRouter(
  initialLocation: CommonPaths.loginPath,
  redirect: _authGuardRedirect,
  observers: [_HistoryNavigatorObserver()],
  routes: [
    GoRoute(
      path: CommonPaths.loginPath,
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(selectedPath: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: CommonPaths.gamesPath,
          redirect: _destinationGuardRedirect(gamesNavDestination),
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.gamePath,
          redirect: _destinationGuardRedirect(gamesNavDestination),
          onExit: _defaultGoBackOnExit(CommonPaths.gamesPath),
          builder: (context, state) {
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
          onExit: _defaultGoBackOnExit(CommonPaths.gamesPath),
          builder: (context, state) {
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
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const LocationListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.locationPath,
          redirect: _destinationGuardRedirect(locationsNavDestination),
          onExit: _defaultGoBackOnExit(CommonPaths.locationsPath),
          builder: (context, state) {
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
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const DeviceListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.devicePath,
          redirect: _destinationGuardRedirect(devicesNavDestination),
          onExit: _defaultGoBackOnExit(CommonPaths.devicesPath),
          builder: (context, state) {
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
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const TagListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.tagPath,
          redirect: _destinationGuardRedirect(tagsNavDestination),
          onExit: _defaultGoBackOnExit(CommonPaths.tagsPath),
          builder: (context, state) {
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
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const PlaythroughListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.playthroughPath,
          redirect: _destinationGuardRedirect(playthroughsNavDestination),
          onExit: _defaultGoBackOnExit(CommonPaths.playthroughsPath),
          builder: (context, state) {
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
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.userPath,
          redirect: _destinationGuardRedirect(usersNavDestination),
          onExit: _defaultGoBackOnExit(CommonPaths.usersPath),
          builder: (context, state) {
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
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const SettingsPage();
          },
        ),

        GoRoute(
          path: CommonPaths.searchPath,
          redirect: _destinationGuardRedirect(searchNavDestination),
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const ExternalGameListPage();
          },
        ),

        GoRoute(
          path: CommonPaths.calendarPath,
          redirect: _destinationGuardRedirect(calendarNavDestination),
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const MultiCalendarPage();
          },
        ),

        GoRoute(
          path: CommonPaths.reviewPath,
          redirect: _destinationGuardRedirect(reviewNavDestination),
          onExit: _goBackOnExit,
          builder: (context, state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const ReviewPage();
          },
        ),

        GoRoute(
          path: CommonPaths.logoutPath,
          redirect: (context, state) {
            context.read<LogoutBloc>().add(ActionStarted.empty());
            return CommonPaths.loginPath;
          },
        ),
      ],
    ),
  ],
);

ExitCallback _defaultGoBackOnExit(String? defaultPath) {
  return (context, state) =>
      _goBackOnExit(context, state, defaultPath: defaultPath);
}

FutureOr<bool> _goBackOnExit(
  BuildContext context,
  GoRouterState state, {
  String? defaultPath,
}) {
  goBack(context, defaultPath: defaultPath);
  return false;
}

GoRouterRedirect? _destinationGuardRedirect(NavDestination destination) {
  final guardRoles = destination.guardRoles;
  return (context, state) => _roleGuardRedirect(context, state, guardRoles);
}

FutureOr<String?> _authGuardRedirect(
  BuildContext context,
  GoRouterState state,
) async {
  final currentLoginResponseBloc = context.read<CurrentLoginResponseGetBloc>();
  final initApiBloc = context.read<ApiClientInitBloc>();
  final currentUserBloc = context.read<CurrentUserGetBloc>();

  currentLoginResponseBloc.add(ActionStarted.empty());
  await currentLoginResponseBloc.stream.firstWhere(
    (actionState) => actionState is ActionFinal<SavedLoginResponse, void>,
  );
  if (currentLoginResponseBloc.state
      is ActionFailure<SavedLoginResponse, void>) {
    return CommonPaths.loginPath;
  }

  initApiBloc.add(
    ActionStarted(
      data:
          (currentLoginResponseBloc.state
                  as ActionSuccess<SavedLoginResponse, void>)
              .data,
    ),
  );
  await initApiBloc.stream.firstWhere(
    (actionState) => actionState is ActionFinal<void, SavedLoginResponse>,
  );
  if (initApiBloc.state is ActionFailure<void, SavedLoginResponse>) {
    return CommonPaths.loginPath;
  }

  if (currentUserBloc.state is ActionInitial) {
    currentUserBloc.add(ActionStarted.empty());
    await currentUserBloc.stream.firstWhere(
      (actionState) => actionState is ActionFinal<UserDTO, void>,
    );
  }
  if (currentUserBloc.state is ActionFailure<UserDTO, void>) {
    return CommonPaths.loginPath;
  }

  return state.uri.path == CommonPaths.loginPath
      ? CommonPaths
            .homePath // TODO redirectUrl pathparam
      : null;
}

FutureOr<String?> _roleGuardRedirect(
  BuildContext context,
  GoRouterState state,
  List<String> roles,
) async {
  final currentUserBloc = context.read<CurrentUserGetBloc>();

  if (currentUserBloc.state is ActionInitial) {
    currentUserBloc.add(ActionStarted.empty());
    await currentUserBloc.stream.firstWhere(
      (actionState) => actionState is ActionFinal<UserDTO, void>,
    );
  }
  if (currentUserBloc.state is ActionFailure<UserDTO, void>) {
    return CommonPaths.loginPath;
  }

  return roles.contains(
        (currentUserBloc.state as ActionSuccess<UserDTO, void>).data.role,
      )
      ? null
      : CommonPaths.homePath;
}
