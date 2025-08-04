import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart'
    show FilterDTO, FormData, ListSearch, SearchDTO;

import 'form.dart' show FormBloc;

class SearchFormData extends FormData<ListSearch> {
  final TextEditingController name;
  final List<FilterDTO> filters; // TODO

  SearchFormData({required this.name, required this.filters});

  @override
  void setValues(final ListSearch? search) {
    name.value = name.value.copyWith(text: search?.name);

    filters.clear();
    if (search?.search.filter != null) {
      filters.addAll(search!.search.filter!);
    }
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
