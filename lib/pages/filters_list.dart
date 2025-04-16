import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/components/grid_list.dart';
import 'package:game_oclock/blocs/blocs.dart' show ListLoaded, SearchListBloc;
import 'package:game_oclock/components/list_item.dart' show ListItemTile;
import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;

class FilterListPage extends StatelessWidget {
  const FilterListPage({super.key, required this.space});

  final String space;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create:
          (_) => SearchListBloc(space: space)..add(
            ListLoaded(
              search: ListSearch(name: 'default', search: SearchDTO()),
            ),
          ),
      child: GridListBuilder<ListSearch, SearchListBloc>(
        space: '',
        itemBuilder:
            (final context, final data) => ListItemTile(
              title: data.name,
              onTap: () {
                Navigator.pop(context, data); // TODO open dialog to edit
              },
            ),
      ),
    );
  }
}
