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
          title: 'Counters', // TODO
          actions: [
            SearchAnchor(
              builder: (final context, final controller) {
                return IconButton(
                  icon: const Icon(CommonIcons.search),
                  onPressed: () {
                    controller.openView();
                  },
                );
              },
              suggestionsBuilder:
                  (final context, final controller) => List.empty(),
              /*viewOnChanged: // TODO not called
                  (final value) => context.read<LB>().add(
                    ListQuicksearchChanged(quicksearch: value),
                  ),*/
            ),
          ],
          fabIcon: const Icon(CommonIcons.add),
          fabLabel: 'Add',
          fabOnPressed:
              () async => showDialog(
                context: context,
                builder: (final context) => const UserGameCreateForm(),
              ),
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
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: false));
            return const UserGameListPage();
          },
          /*routes: <RouteBase>[
            GoRoute(
              path: 'details',
              builder: (BuildContext context, GoRouterState state) {
                return const DetailsScreen(label: 'A');
              },
            ),
          ],*/
        ),
        GoRoute(
          path: CommonPaths.locationsPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: false));
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.devicesPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: false));
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.tagsPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: true));
            return const UserGameListPage();
          },
        ),
        GoRoute(
          path: CommonPaths.usersPath,
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: true));
            return const UserGameListPage();
          },
        ),
      ],
    ),
  ],
);
