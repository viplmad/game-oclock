import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart'
    show FilterDTO, FormData, ListSearch, SearchDTO;

import 'form.dart' show FormBloc;

class SearchFormData extends FormData<ListSearch> {
  final TextEditingController name;
  final List<FilterFormData> filters; // TODO

  SearchFormData({required this.name, required this.filters});

  @override
  void setValues(final ListSearch? search) {
    name.value = name.value.copyWith(text: search?.name);

    filters.clear();
    if (search?.search.filter != null) {
      filters.addAll(
        search!.search.filter!.map(
          (final filter) => FilterFormData(
            field: TextEditingController(),
            operator: TextEditingController(),
            value: TextEditingController(),
            chainOperator: TextEditingController(),
          )..setValues(filter),
        ),
      );
    }
  }
}

class FilterFormData extends FormData<FilterDTO> {
  final TextEditingController field;
  final TextEditingController operator;
  final TextEditingController value;
  final TextEditingController chainOperator;

  FilterFormData({
    required this.field,
    required this.operator,
    required this.value,
    required this.chainOperator,
  });

  @override
  void setValues(final FilterDTO? filter) {
    field.value = field.value.copyWith(text: filter?.field);
    operator.value = operator.value.copyWith(text: filter?.operator_.value);
    value.value = value.value.copyWith(text: filter?.value.value); // TODO
    chainOperator.value = chainOperator.value.copyWith(
      text: filter?.chainOperator?.value,
    );
  }
}

class SearchFormBloc extends FormBloc<SearchFormData, ListSearch> {
  SearchFormBloc({required super.formGroup});

  @override
  ListSearch fromDynamicMap(final SearchFormData values) {
    return ListSearch(
      name: values.name.value.text,
      search: SearchDTO(), // TODO
    );
  }
}
