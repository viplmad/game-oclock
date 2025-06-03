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
import 'package:game_oclock/pages/counter_form.dart' show CounterCreateForm;
import 'package:game_oclock/pages/counter_list.dart';
import 'package:game_oclock/pages/destinations.dart'
    show mainDestinations, secondaryDestinations;
import 'package:game_oclock/pages/login.dart' show LoginPage;
import 'package:go_router/go_router.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
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
          title: 'Counters',
          actions: [],
          fabIcon: const Icon(Icons.add),
          fabLabel: 'Add',
          fabOnPressed:
              () async => showDialog(
                context: context,
                builder: (final context) => const CounterCreateForm(),
              ),
          selectedPath: state.uri.path,
          mainDestinations: mainDestinations,
          secondaryDestinations: secondaryDestinations,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/a',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: false));
            return const CounterListPage();
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
          path: '/b',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: false));
            return const CounterListPage();
          },
        ),
        GoRoute(
          path: '/c',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: false));
            return const CounterListPage();
          },
        ),
        GoRoute(
          path: '/x',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: true));
            return const CounterListPage();
          },
        ),
        GoRoute(
          path: '/y',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: true));
            return const CounterListPage();
          },
        ),
        GoRoute(
          path: '/z',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: true));
            return const CounterListPage();
          },
        ),
      ],
    ),
  ],
);
