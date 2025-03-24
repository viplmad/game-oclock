import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/blocs.dart'
    show
        ActionFinal,
        ActionInProgress,
        ActionStarted,
        ActionState,
        CounterFormBloc,
        CounterProducerBloc,
        FormState2,
        FormStateSubmitInProgress,
        FormSubmitted,
        LayoutContextChanged,
        LayoutTierBloc,
        LayoutTierState;
import 'models/models.dart' show FormControl, FormGroup;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CounterProducerBloc()),
          BlocProvider(create: (_) => LayoutTierBloc()),
          BlocProvider(
            create:
                (_) => CounterFormBloc(
                  formGroup: FormGroup(
                    forms: <String, FormControl<dynamic>>{
                      'count': FormControl(),
                    },
                  ),
                ),
          ),
        ],
        child: const SelectionArea(
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(final BuildContext context) {
    final mediaQuerySize = MediaQuery.sizeOf(context);
    context.read<LayoutTierBloc>().add(
      LayoutContextChanged(size: mediaQuerySize),
    );
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LayoutTierBloc, LayoutTierState>(
            listener: (final context, final state) {
              print('This layout is a $state');
            },
          ),
          BlocListener<CounterFormBloc, FormState2>(
            listener: (final context, final state) {
              final snackBar = SnackBar(content: Text('This form is a $state'));
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
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
              const Text('Test text field'),
              BlocBuilder<CounterFormBloc, FormState2>(
                builder: (final context, final state) {
                  return Form(
                    key: state.key,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          readOnly: state is FormStateSubmitInProgress,
                          onSaved: state.group.getControl('count').onSave,
                          // The validator receives the text that the user has entered.
                          validator: (final value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
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
                      context.read<CounterFormBloc>().add(FormSubmitted());
                    },
            tooltip: 'Increment',
            child:
                state is ActionInProgress
                    ? const CircularProgressIndicator() // TODO smaller
                    : const Icon(Icons.add),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
