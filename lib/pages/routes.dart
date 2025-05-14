import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show CounterProducerBloc, LayoutContextChanged, LayoutTierBloc;
import 'package:game_oclock/pages/home.dart' show HomePage;
import 'package:go_router/go_router.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (final context, final state) {
        final mediaQuerySize = MediaQuery.sizeOf(context);
        context.read<LayoutTierBloc>().add(
          LayoutContextChanged(size: mediaQuerySize),
        );

        return BlocProvider(
          create: (_) => CounterProducerBloc(),
          child: const SelectionArea(child: HomePage()),
        );
      },
    ),
  ],
);
