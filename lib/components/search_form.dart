import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        FilterFormData,
        FilterFormDataListBloc,
        ListLoaded,
        ListReloaded,
        SearchCreateBloc,
        SearchFormBloc,
        SearchFormData,
        SearchGetBloc,
        SearchUpdateBloc;
import 'package:game_oclock/constants/form_validators.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show ListSearch, SearchDTO, gameFields, operatorsMenuEntries;

import 'create_edit_form.dart';
import 'tile_list.dart';

class SearchCreateForm extends StatelessWidget {
  const SearchCreateForm({super.key, required this.space});

  final String space;

  @override
  Widget build(final BuildContext context) {
    final List<FilterFormData> mutableFilters = List.empty(growable: true);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => SearchFormBloc(
                formGroup: SearchFormData(
                  name: TextEditingController(),
                  filters: mutableFilters,
                ),
              ),
        ),
        BlocProvider(create: (_) => SearchCreateBloc(space: space)),
        BlocProvider(
          create:
              (_) => FilterFormDataListBloc(data: mutableFilters)..add(
                ListLoaded(
                  search: ListSearch(name: 'default', search: SearchDTO()),
                ),
              ),
        ),
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
    final List<FilterFormData> mutableFilters = List.empty(growable: true);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return SearchFormBloc(
              formGroup: SearchFormData(
                name: TextEditingController(),
                filters: mutableFilters,
              ),
            );
          },
        ),
        BlocProvider(create: (_) => SearchUpdateBloc(space: space)),
        BlocProvider(
          create:
              (_) =>
                  SearchGetBloc(space: space)..add(ActionStarted(data: name)),
        ),
        BlocProvider(
          create:
              (_) => FilterFormDataListBloc(data: mutableFilters)..add(
                ListLoaded(
                  search: ListSearch(name: 'default', search: SearchDTO()),
                ),
              ),
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
  context.read<FilterFormDataListBloc>().add(const ListReloaded());
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
      ReorderableListBuilder<FilterFormData, FilterFormDataListBloc>(
        // TODO readonly
        space: '', // Empty space because filter is not allowed
        onReorder: (final oldIndex, final newIndex) {
          context.read<FilterFormDataListBloc>().replaceElement(
            oldIndex,
            newIndex,
          );
        },
        itemBuilder:
            (final context, final data, final index) => ListTile(
              // TODO Missing chainOperator
              title: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownMenu<String>(
                      controller: data.field,
                      enableFilter: true,
                      requestFocusOnTap: true,
                      label: const Text('Field'), // TODO
                      dropdownMenuEntries: gameFields,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownMenu<String>(
                      controller: data.operator,
                      enableFilter: true,
                      requestFocusOnTap: true,
                      label: const Text('Operator'), // TODO
                      dropdownMenuEntries: operatorsMenuEntries,
                    ),
                  ),
                ],
              ),
              subtitle: TextFormField(
                controller: data.value,
                readOnly: readOnly,
                validator: notEmptyValidator,
                decoration: const InputDecoration(
                  labelText: 'Value', // TODO
                ),
              ),
              trailing: IconButton(
                icon: const Icon(CommonIcons.delete),
                onPressed: () {
                  context.read<FilterFormDataListBloc>().removeElement(index);
                },
              ),
            ),
      ),
      TextButton.icon(
        label: const Text('Add'),
        icon: const Icon(CommonIcons.add),
        onPressed: () {
          context.read<FilterFormDataListBloc>().addElement(
            FilterFormData(
              field: TextEditingController(),
              operator: TextEditingController(),
              value: TextEditingController(),
              chainOperator: TextEditingController(),
            ),
          );
        },
      ),
    ],
  );
}
