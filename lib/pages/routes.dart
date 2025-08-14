import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        LayoutContextChanged,
        LayoutTierBloc,
        MinimizedLayoutBloc;
import 'package:game_oclock/components/adaptive_layout.dart'
    show AdaptiveLayoutBuilder;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/pages/destinations.dart'
    show mainDestinations, secondaryDestinations;
import 'package:game_oclock/pages/games/game_detail.dart'
    show UserGameDetailsPage;
import 'package:game_oclock/pages/games/game_form.dart' show UserGameCreateForm;
import 'package:game_oclock/pages/games/game_list.dart' show UserGameListPage;
import 'package:game_oclock/pages/login/login.dart' show LoginPage;
import 'package:go_router/go_router.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  initialLocation: CommonPaths.loginPath,
  routes: [
    GoRoute(
      path: CommonPaths.loginPath,
      builder: (final BuildContext context, final GoRouterState state) {
        final mediaQuerySize = MediaQuery.sizeOf(context);
        context.read<LayoutTierBloc>().add(
          LayoutContextChanged(size: mediaQuerySize),
        );

        return const LoginPage();
      },
    ),
    ShellRoute(
      builder: (final context, final state, final child) {
        final mediaQuerySize = MediaQuery.sizeOf(context);
        context.read<LayoutTierBloc>().add(
          LayoutContextChanged(size: mediaQuerySize),
        );

        return AdaptiveLayoutBuilder(
          fabIcon: const Icon(CommonIcons.add),
          fabLabel: 'Add',
          fabOnPressed:
              () async => showDialog<bool>(
                context: context,
                builder: (final context) => const UserGameCreateForm(),
              ).then((final bool? success) {
                if (success != null && success) {
                  // TODO refresh list
                }
              }),
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
            final String id = state.pathParameters[CommonPaths.idPathParam]!;
            return UserGameDetailsPage(id: id);
          },
        ),

        GoRoute(
          path: CommonPaths.locationsPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.devicesPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: false),
            );
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.tagsPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.usersPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(
              const ActionStarted(data: true),
            );
            return const UserGameListPage();
          },
        ),
      ],
    ),
  ],
);
