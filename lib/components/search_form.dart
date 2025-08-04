import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        SearchCreateBloc,
        SearchFormBloc,
        SearchFormData,
        SearchGetBloc,
        SearchUpdateBloc;
import 'package:game_oclock/constants/form_validators.dart';
import 'package:game_oclock/models/models.dart' show FilterDTO, ListSearch;

import 'create_edit_form.dart';
import 'list_item.dart';
import 'tile_list.dart';

class SearchCreateForm extends StatelessWidget {
  const SearchCreateForm({super.key, required this.space});

  final String space;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => SearchFormBloc(
                formGroup: SearchFormData(
                  name: TextEditingController(),
                  filters: List.empty(growable: true),
                ),
              ),
        ),
        BlocProvider(create: (_) => SearchCreateBloc(space: space)),
      ],
      child: const CreateEditFormBuilder<
        ListSearch,
        SearchFormData,
        SearchFormBloc,
        SearchGetBloc,
        SearchCreateBloc,
        SearchUpdateBloc
      >(title: 'Creating', create: true, fieldsBuilder: _fieldsBuilder),
    );
  }
}

class SearchEditForm extends StatelessWidget {
  const SearchEditForm({super.key, required this.space, required this.name});

  final String space;
  final String name;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => SearchFormBloc(
                formGroup: SearchFormData(
                  name: TextEditingController(),
                  filters: List.empty(growable: true),
                ),
              ),
        ),
        BlocProvider(create: (_) => SearchUpdateBloc(space: space)),
        BlocProvider(
          create:
              (_) =>
                  SearchGetBloc(space: space)..add(ActionStarted(data: name)),
        ),
      ],
      child: const CreateEditFormBuilder<
        ListSearch,
        SearchFormData,
        SearchFormBloc,
        SearchGetBloc,
        SearchCreateBloc,
        SearchUpdateBloc
      >(title: 'Editing', create: false, fieldsBuilder: _fieldsBuilder),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final SearchFormData formGroup,
  final bool readOnly,
) {
  return Column(
    children: <Widget>[
      TextFormField(
        controller: formGroup.name,
        readOnly: readOnly,
        validator: notEmptyValidator,
        decoration: const InputDecoration(
          labelText: 'Name', // TODO
        ),
      ),
      ReorderableTileList<FilterDTO>(
        controller: ScrollController(), // TODO
        items: formGroup.filters,
        itemBuilder:
            (final context, final data) => ListItemTile(
              title: '${data.field}${data.operator_.value}${data.value}',
              subtitle: data.chainOperator?.value ?? '',
            ),
      ),
    ],
  );
}
