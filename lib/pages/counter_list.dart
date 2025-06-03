import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show Counter, CounterListBloc, CounterSelectBloc, ListLoaded;
import 'package:game_oclock/components/detail.dart' show Detail;
import 'package:game_oclock/components/list_detail.dart' show ListDetailBuilder;
import 'package:game_oclock/components/list_item.dart' show ListItemGrid;
import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;
import 'package:game_oclock/pages/counter_form.dart' show CounterEditForm;

class CounterListPage extends StatelessWidget {
  const CounterListPage({super.key});

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
              (_) =>
                  CounterListBloc()..add(
                    ListLoaded(
                      search: ListSearch(name: 'default', search: SearchDTO()),
                    ),
                  ),
        ),
      ],
      child: ListDetailBuilder<Counter, CounterSelectBloc, CounterListBloc>(
        filterSpace: 'counter',
        detailBuilder:
            (final context, final data, final onClosed) => Detail(
              title: data.name,
              imageUrl:
                  'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/224760/header.jpg',
              onBackPressed: onClosed,
              onEditPressed:
                  () async => showDialog(
                    context: context,
                    builder: (final context) => const CounterEditForm(),
                  ),
              content: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: Column(children: [Text(data.data.toString())]),
                  ),
                  const Flexible(
                    flex: 2,
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: [
                              Tab(icon: Icon(Icons.directions_car)),
                              Tab(icon: Icon(Icons.directions_transit)),
                              Tab(icon: Icon(Icons.directions_bike)),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Icon(Icons.directions_car),
                                Icon(Icons.directions_transit),
                                Icon(Icons.directions_bike),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        listItemBuilder:
            (final context, final data, final onPressed) => ListItemGrid(
              title: '${data.name} ${data.data}',
              onTap: onPressed,
            ),
      ),
    );
  }
}
