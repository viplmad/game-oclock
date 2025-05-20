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
import 'package:game_oclock/components/create_edit_form.dart' show CreateForm;
import 'package:game_oclock/pages/counter_list_detail.dart';
import 'package:game_oclock/pages/destinations.dart'
    show mainDestinations, secondaryDestinations;
import 'package:go_router/go_router.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  initialLocation: '/a',
  routes: [
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
                builder: (final context) => const CreateForm(),
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
            return const CounterListDetail();
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
            return const CounterListDetail();
          },
        ),
        GoRoute(
          path: '/c',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: false));
            return const CounterListDetail();
          },
        ),
        GoRoute(
          path: '/x',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: true));
            return const CounterListDetail();
          },
        ),
        GoRoute(
          path: '/y',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: true));
            return const CounterListDetail();
          },
        ),
        GoRoute(
          path: '/z',
          builder: (final BuildContext context, final GoRouterState state) {
            context.read<MinimizedLayoutBloc>().add(ActionStarted(data: true));
            return const CounterListDetail();
          },
        ),
      ],
    ),
  ],
);
