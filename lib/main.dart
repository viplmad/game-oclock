import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock/blocs/blocs.dart'
    show CounterProducerBloc, LayoutContextChanged, LayoutTierBloc;
import 'package:game_oclock/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (_) => LayoutTierBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
          ),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (_) => CounterProducerBloc(),
          child: const SelectionArea(
            child: MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) {
    final mediaQuerySize = MediaQuery.sizeOf(context);
    context.read<LayoutTierBloc>().add(
      LayoutContextChanged(size: mediaQuerySize),
    );

    return const HomePage();
  }
}
