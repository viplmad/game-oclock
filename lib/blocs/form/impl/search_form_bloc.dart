import 'package:game_oclock/models/models.dart'
    show
        ChainOperatorType,
        FilterDTO,
        ListSearch,
        OperatorType,
        SearchDTO,
        SearchFormData,
        SearchValue;

import '../form.dart' show FormBloc;

class SearchFormBloc extends FormBloc<SearchFormData, ListSearch> {
  SearchFormBloc({required super.formGroup});

  @override
  ListSearch fromData(final SearchFormData values) {
    return ListSearch(
      name: values.name.text,
      search: SearchDTO(
        filter: values.filters
            .map(
              (final filterValues) => FilterDTO(
                field: filterValues.field.text,
                operator_: OperatorType.fromJson(filterValues.operator.text)!,
                value: SearchValue(value: filterValues.value.text),
                chainOperator: ChainOperatorType.fromJson(
                  filterValues.chainOperator.text,
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
