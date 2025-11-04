import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        FilterFormDataListBloc,
        ListReloaded,
        ListSearchChanged,
        SearchCreateBloc,
        SearchFormBloc,
        SearchGetBloc,
        SearchUpdateBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show
        FilterFormData,
        ListSearch,
        SearchDTO,
        SearchFormData,
        gameFieldOptions,
        operatorOptions;
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
        BlocProvider(
          create: (_) => SearchCreateBloc(
            space: space,
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) =>
              FilterFormDataListBloc(data: mutableFilters)
                ..add(ListSearchChanged(search: SearchDTO())),
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
        BlocProvider(
          create: (_) => SearchUpdateBloc(
            space: space,
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => SearchGetBloc(
            space: space,
            service: RepositoryProvider.of(context),
          )..add(ActionStarted(data: name)),
        ),
        BlocProvider(
          create: (_) =>
              FilterFormDataListBloc(data: mutableFilters)
                ..add(ListSearchChanged(search: SearchDTO())),
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
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        controller: formGroup.name,
        required: true,
        readOnly: readOnly,
        label: context.localize().nameLabel,
      ),
      ReorderableListBuilder<FilterFormData, FilterFormDataListBloc>(
        readOnly: readOnly,
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
                child: SimpleSelectFormField(
                  controller: data.field,
                  label: context.localize().fieldLabel,
                  required: true,
                  options: gameFieldOptions,
                ),
              ),
              Expanded(
                flex: 1,
                child: SimpleSelectFormField(
                  controller: data.operator,
                  label: context.localize().operatorLabel,
                  required: true,
                  options: operatorOptions,
                ),
              ),
            ],
          ),
          subtitle: SimpleTextFormField(
            controller: data.value,
            required: true,
            readOnly: readOnly,
            label: context.localize().valueLabel,
          ),
          trailing: IconButton(
            icon: CommonIcons.delete,
            tooltip: context.localize().deleteLabel,
            onPressed: () {
              context.read<FilterFormDataListBloc>().removeElement(index);
            },
          ),
        ),
      ),
      TextButton.icon(
        label: Text(context.localize().addLabel),
        icon: CommonIcons.add,
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
