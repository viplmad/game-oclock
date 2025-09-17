import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart'
    show FilterDTO, FormData, ListSearch;
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class SearchFormData extends FormData<ListSearch> {
  final TextEditingController name;
  final List<FilterFormData> filters; // TODO

  SearchFormData({required this.name, required this.filters});

  @override
  void setValues(final ListSearch? search) {
    name.setValue(search?.name);

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
    field.setValue(filter?.field);
    operator.setValue(filter?.operator_.value);
    value.setValue(filter?.value.value); // TODO list
    chainOperator.setValue(filter?.chainOperator?.value);
  }
}
