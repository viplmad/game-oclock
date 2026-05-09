import 'package:equatable/equatable.dart';
import 'package:game_oclock_client/api.dart';

final class ListSearch extends Equatable {
  final String id;
  final String name;
  final bool internal;
  final List<FilterDTO>? filter;
  final List<SortDTO>? sort;

  ListSearch.def() : this(id: '-1', name: '-', filter: [], sort: []);
  const ListSearch({
    required this.id,
    required this.name,
    this.internal = false,
    required this.filter,
    required this.sort,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'id'] = id;
    json[r'name'] = name;
    json[r'filter'] = filter;
    json[r'sort'] = sort;
    return json;
  }

  static ListSearch fromJson(final dynamic value) {
    final json = value.cast<String, dynamic>();

    return ListSearch(
      id: json[r'id'],
      name: json[r'name']!,
      filter: FilterDTO.listFromJson(json[r'filter']),
      sort: SortDTO.listFromJson(json[r'sort']),
    );
  }

  @override
  List<Object?> get props => [name, filter, sort];
}
