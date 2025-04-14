import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionInProgress,
        ActionStarted,
        ActionState,
        CounterProducerBloc,
        LayoutContextChanged,
        LayoutTierBloc;
import 'package:game_oclock/components/grid_list.dart' show CounterList;
import 'package:game_oclock/components/create_edit_form.dart'
    show CreateForm, EditForm;
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            BlocBuilder<CounterProducerBloc, ActionState<int>>(
              builder: (final context, final state) {
                int counter = 0;
                if (state is ActionFinal<int>) {
                  counter = state.data;
                }
                if (state is ActionInProgress<int>) {
                  counter = state.data ?? counter;
                }

                return Text(
                  '$counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            TextButton(
              child: const Text('Open create form'),
              onPressed:
                  () async => showDialog(
                    context: context,
                    builder: (final context) => const CreateForm(),
                  ),
            ),
            TextButton(
              child: const Text('Open edit form'),
              onPressed:
                  () async => showDialog(
                    context: context,
                    builder: (final context) => const EditForm(),
                  ),
            ),
            TextButton(
              child: const Text('Open home'),
              onPressed:
                  () async => showDialog(
                    context: context,
                    builder:
                        (final context) =>
                            const Dialog.fullscreen(child: HomePageStarter()),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<CounterProducerBloc, ActionState<int>>(
        builder: (final context, final state) {
          return FloatingActionButton(
            onPressed:
                state is ActionInProgress
                    ? null
                    : () {
                      context.read<CounterProducerBloc>().add(
                        ActionStarted.empty(),
                      );
                    },
            tooltip: 'Increment',
            child:
                state is ActionInProgress
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
