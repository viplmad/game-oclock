import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show Counter, CounterListBloc, CounterSelectBloc, ListLoaded;
import 'package:game_oclock/components/list_detail_layout.dart';
import 'package:game_oclock/components/list_item.dart' show ListItemGrid;
import 'package:game_oclock/models/models.dart' show SearchDTO;

class HomePageStarter extends StatelessWidget {
  const HomePageStarter({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return CounterSelectBloc();
          },
        ),
        BlocProvider(
          create:
              (_) => CounterListBloc()..add(ListLoaded(search: SearchDTO())),
        ),
      ],
      child: ListDetailLayout<Counter, CounterSelectBloc, CounterListBloc>(
        title: 'Counters',
        fabIcon: const Icon(Icons.add),
        fabLabel: 'Add',
        fabOnPressed: () => {},
        detailBuilder:
            (final context, final data, final onClosed) => Scaffold(
              appBar: AppBar(
                title: Text(data.name),
                automaticallyImplyLeading: false,
                leading: BackButton(onPressed: onClosed),
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                  left: 24.0,
                  right: 24.0,
                ),
                child: SingleChildScrollView(child: Text(data.data.toString())),
              ),
            ),
        listItemBuilder:
            (final context, final data, final onPressed) => ListItemGrid(
              title: '${data.name} ${data.data}',
              onTap: onPressed,
            ),
        mainDestinations: List.of([
          const NavigationDestination(icon: Icon(Icons.abc), label: '1'),
          const NavigationDestination(
            icon: Icon(Icons.app_blocking),
            label: '2',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_balance),
            label: '3',
          ),
        ], growable: false),
        secondaryDestinations: List.of([
          const NavigationDestination(
            icon: Icon(Icons.one_x_mobiledata),
            label: 'x',
          ),
          const NavigationDestination(icon: Icon(Icons.yard), label: 'y'),
          const NavigationDestination(icon: Icon(Icons.zoom_in), label: 'z'),
        ], growable: false),
      ),
    );
  }
}
