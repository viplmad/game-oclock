import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ListSearchCreateBloc,
        ListSearchGetBloc,
        ListSearchUpdateBloc,
        SearchFormBloc;
import 'package:game_oclock/components/forms/create_edit_form.dart';
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show ListSearch, SearchFormData, gameFieldOptions, operatorOptions;
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SearchCreateForm extends StatelessWidget {
  const SearchCreateForm({super.key, required this.space});

  final String space;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchFormBloc(
            data: SearchFormData(
              name: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              filters: FormArray([]),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ListSearchCreateBloc(
            service: RepositoryProvider.of(context),
            space: space,
          ),
        ),
      ],
      child:
          CreateFormBuilder<
            ListSearch,
            SearchFormData,
            SearchFormBloc,
            ListSearchCreateBloc
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return SearchFormBloc(
              data: SearchFormData(
                name: FormControl<String>(
                  validators: [NotEmptyValidator(context)],
                ),
                filters: FormArray([]),
              ),
            );
          },
        ),
        BlocProvider(
          create: (_) => ListSearchUpdateBloc(
            service: RepositoryProvider.of(context),
            space: space,
          ),
        ),
        BlocProvider(
          create: (_) => ListSearchGetBloc(
            service: RepositoryProvider.of(context),
            space: space,
          )..add(ActionStarted(data: name)),
        ),
      ],
      child:
          EditFormBuilder<
            ListSearch,
            SearchFormData,
            SearchFormBloc,
            ListSearchGetBloc,
            ListSearchUpdateBloc
          >(
            title: context.localize().editingTitle,
            fieldsBuilder: _fieldsBuilder,
          ),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final SearchFormData formData,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        formControl: formData.name,
        label: context.localize().nameLabel,
        readOnly: readOnly,
      ),
      ReactiveFormArray(
        formArray: formData.filters,
        builder: (final context, final formArray, final child) {
          return ReorderableTileList(
            readOnly: readOnly,
            items: formArray.controls,
            onReorder: (final oldIndex, final newIndex) {
              final temp = formArray.removeAt(oldIndex);
              formArray.insert(newIndex, temp);
            },
            itemBuilder: (final context, final data, final index) {
              final formGroup = data as FormGroup;
              return ListTile(
                key: Key('${formGroup.hashCode}'),
                // TODO Missing chainOperator
                title: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SimpleSelectFormField(
                        formControl:
                            formGroup.controls['field'] as FormControl<String>,
                        label: context.localize().fieldLabel,
                        options: gameFieldOptions,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SimpleSelectFormField(
                        formControl:
                            formGroup.controls['operator']
                                as FormControl<String>,
                        label: context.localize().operatorLabel,
                        options: operatorOptions,
                      ),
                    ),
                  ],
                ),
                subtitle: SimpleTextFormField(
                  formControl:
                      formGroup.controls['value'] as FormControl<String>,
                  label: context.localize().valueLabel,
                  readOnly: readOnly,
                ),
                trailing: IconButton(
                  icon: CommonIcons.delete,
                  tooltip: context.localize().deleteLabel,
                  onPressed: () {
                    formArray.removeAt(index);
                  },
                ),
              );
            },
          );
        },
      ),
      TextButton.icon(
        label: Text(context.localize().addFilterLabel),
        icon: CommonIcons.add,
        onPressed: () {
          formData.filters.add(
            FormGroup({
              'field': FormControl<String>(),
              'operator': FormControl<String>(),
              'value': FormControl<String>(),
              'chainOperator': FormControl<String>(),
            }),
          );
        },
      ),
    ],
  );
}
