import 'package:game_oclock/models/models.dart' show ListSearch, SearchFormData;
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../form.dart' show FormBloc;

class SearchFormBloc extends FormBloc<SearchFormData, ListSearch, ListSearch> {
  SearchFormBloc({required super.data});

  @override
  ListSearch fromFormData(final SearchFormData data) {
    return ListSearch(
      id: '', // TODO
      name: data.name.value!,
      filter: (data.filters.controls as List<FormGroup>)
          .map(
            (final filterValues) => FilterDTO(
              field: (filterValues.controls['field'] as FormControl<String>)
                  .value!,
              operator_: OperatorType.fromJson(
                (filterValues.controls['operator'] as FormControl<String>)
                    .value,
              )!,
              value: SearchValue(
                value: (filterValues.controls['value'] as FormControl<String>)
                    .value,
              ),
              chainOperator: ChainOperatorType.fromJson(
                (filterValues.controls['chainOperator'] as FormControl<String>)
                    .value,
              ),
            ),
          )
          .toList(growable: false),
      sort: const [],
    );
  }

  @override
  void setFormValue(final SearchFormData data, final ListSearch? value) {
    data.name.value = value?.name;
    data.filters.value = value?.filter
        ?.map(
          (final filter) => FormGroup({
            'field': FormControl<String>(value: filter.field),
            'operator': FormControl<String>(value: filter.operator_.toJson()),
            'value': FormControl<String>(value: filter.value!.value), // TODO
            'chainOperator': FormControl<String>(
              value: filter.chainOperator?.toJson(),
            ),
          }),
        )
        .toList(growable: false);
  }
}
