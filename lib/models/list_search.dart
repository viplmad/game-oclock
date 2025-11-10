import 'package:equatable/equatable.dart';

import 'models.dart' show SearchDTO;

final class ListSearch extends Equatable {
  final String id;
  final String name;
  final SearchDTO search;

  ListSearch.def() : this(id: '-1', name: '-', search: SearchDTO());
  const ListSearch({
    required this.id,
    required this.name,
    required this.search,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'id'] = id;
    json[r'name'] = name;
    json[r'search'] = search.toJson();
    return json;
  }

  static ListSearch fromJson(final dynamic value) {
    final json = value.cast<String, dynamic>();

    return ListSearch(
      id: json[r'id'],
      name: json[r'name']!,
      search: SearchDTO.fromJson(json[r'search'])!,
    );
  }

  @override
  List<Object?> get props => [name, search];
}
