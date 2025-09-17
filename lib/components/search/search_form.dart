import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        FilterFormDataListBloc,
        ListLoaded,
        ListReloaded,
        SearchCreateBloc,
        SearchFormBloc,
        SearchGetBloc,
        SearchUpdateBloc;
import 'package:game_oclock/components/create_edit_form.dart';
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/constants/form_validators.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show
        FilterFormData,
        ListSearch,
        SearchDTO,
        SearchFormData,
        gameFields,
        operatorsMenuEntries;
import 'package:game_oclock/utils/localisation_extension.dart';

class SearchCreateForm extends StatelessWidget {
  const SearchCreateForm({super.key, required this.space});

  final String space;

  @override
  Widget build(final BuildContext context) {
    final List<FilterFormData> mutableFilters = List.empty(growable: true);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchFormBloc(
            formGroup: SearchFormData(
              name: TextEditingController(),
              filters: mutableFilters,
            ),
          ),
        ),
        BlocProvider(create: (_) => SearchCreateBloc(space: space)),
        BlocProvider(
          create: (_) => FilterFormDataListBloc(data: mutableFilters)
            ..add(
              ListLoaded(
                search: ListSearch(name: 'default', search: SearchDTO()),
              ),
            ),
        ),
      ],
      child:
          CreateFormBuilder<
            ListSearch,
            SearchFormData,
            SearchFormBloc,
            SearchCreateBloc
          >(
            title: context.localize().creatingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
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
          create: (_) =>
              SearchGetBloc(space: space)..add(ActionStarted(data: name)),
        ),
        BlocProvider(
          create: (_) => FilterFormDataListBloc(data: mutableFilters)
            ..add(
              ListLoaded(
                search: ListSearch(name: 'default', search: SearchDTO()),
              ),
            ),
        ),
      ],
      child:
          EditFormBuilder<
            ListSearch,
            SearchFormData,
            SearchFormBloc,
            SearchGetBloc,
            SearchUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
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
        validator: (final value) => notEmptyValidator(context, value),
        decoration: InputDecoration(labelText: context.localize().nameLabel),
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
        itemBuilder: (final context, final data, final index) => ListTile(
          // TODO Missing chainOperator
          title: Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownMenu<String>(
                  controller: data.field,
                  enableFilter: true,
                  requestFocusOnTap: true,
                  label: Text(context.localize().fieldLabel),
                  dropdownMenuEntries: gameFields
                      .map(
                        (final field) => DropdownMenuEntry<String>(
                          value: field.value,
                          label: field.labelBuilder(context),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              Expanded(
                flex: 1,
                child: DropdownMenu<String>(
                  controller: data.operator,
                  enableFilter: true,
                  requestFocusOnTap: true,
                  label: Text(context.localize().operatorLabel),
                  dropdownMenuEntries: operatorsMenuEntries
                      .map(
                        (final field) => DropdownMenuEntry<String>(
                          value: field.value,
                          label: field.labelBuilder(context),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ],
          ),
          subtitle: TextFormField(
            controller: data.value,
            readOnly: readOnly,
            validator: (final value) => notEmptyValidator(context, value),
            decoration: InputDecoration(
              labelText: context.localize().valueLabel,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(CommonIcons.delete),
            tooltip: context.localize().deleteLabel,
            onPressed: () {
              context.read<FilterFormDataListBloc>().removeElement(index);
            },
          ),
        ),
      ),
      TextButton.icon(
        label: Text(context.localize().addLabel),
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
