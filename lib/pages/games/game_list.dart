import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ListLoaded, UserGameListBloc, UserGameSelectBloc;
import 'package:game_oclock/components/detail.dart' show Detail;
import 'package:game_oclock/components/list_detail.dart' show ListDetailBuilder;
import 'package:game_oclock/components/list_item.dart' show ListItemGrid;
import 'package:game_oclock/models/models.dart'
    show ListSearch, SearchDTO, UserGame;
import 'package:game_oclock/pages/games/game_form.dart' show UserGameEditForm;

class UserGameListPage extends StatelessWidget {
  const UserGameListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return UserGameSelectBloc();
          },
        ),
        BlocProvider(
          create:
              (_) =>
                  UserGameListBloc()..add(
                    ListLoaded(
                      search: ListSearch(name: 'default', search: SearchDTO()),
                    ),
                  ),
        ),
      ],
      child: ListDetailBuilder<UserGame, UserGameSelectBloc, UserGameListBloc>(
        searchSpace: 'game',
        detailBuilder:
            (final context, final data, final onClosed) => Detail(
              title: data.title,
              imageUrl: data.coverUrl,
              onBackPressed: onClosed,
              onEditPressed:
                  () async => showDialog(
                    context: context,
                    builder: (final context) => UserGameEditForm(id: data.id),
                  ),
              content: Column(
                children: [
                  Flexible(flex: 3, child: Column(children: [Text(data.id)])),
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
              title:
                  '${data.title}${data.edition.isNotEmpty ? ' - ${data.edition}' : ''}',
              onTap: onPressed,
            ),
      ),
    );
  }
}
