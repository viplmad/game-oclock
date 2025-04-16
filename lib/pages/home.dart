import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show Counter, CounterListBloc, CounterSelectBloc, ListLoaded;
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/list_detail_layout.dart';
import 'package:game_oclock/components/list_item.dart' show ListItemGrid;
import 'package:game_oclock/models/models.dart' show SearchDTO;

import 'package:game_oclock/pages/destinations.dart'
    show mainDestinations, secondaryDestinations;

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
        actions: [],
        fabIcon: const Icon(Icons.add),
        fabLabel: 'Add',
        fabOnPressed: () => {},
        detailBuilder:
            (final context, final data, final onClosed) => Detail(
              title: data.name,
              onBackPressed: onClosed,
              content: SingleChildScrollView(child: Text(data.data.toString())),
            ),
        listItemBuilder:
            (final context, final data, final onPressed) => ListItemGrid(
              title: '${data.name} ${data.data}',
              onTap: onPressed,
            ),
        mainDestinations: mainDestinations,
        secondaryDestinations: secondaryDestinations,
      ),
    );
  }
}
