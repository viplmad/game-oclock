import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:game_oclock_client/api.dart';

final class ListSearch extends Equatable {
  final String id;
  final String name;
  final String Function(BuildContext context)? _labelBuilder;
  final bool internal;
  final List<FilterDTO>? filter;
  final List<SortDTO>? sort;

  String Function(BuildContext context) get labelBuilder =>
      _labelBuilder ?? (final context) => name;

  ListSearch.def() : this.manual(id: '-1', name: '-', filter: [], sort: []);
  const ListSearch.manual({
    required this.id,
    required this.name,
    required this.filter,
    required this.sort,
  }) : internal = false,
       _labelBuilder = null;

  const ListSearch.internal({
    required this.id,
    required final String Function(BuildContext context) labelBuilder,
    required this.filter,
    required this.sort,
  }) : internal = true,
       name = id,
       _labelBuilder = labelBuilder;

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

    return ListSearch.manual(
      id: json[r'id'],
      name: json[r'name']!,
      filter: FilterDTO.listFromJson(json[r'filter']),
      sort: SortDTO.listFromJson(json[r'sort']),
    );
  }

  @override
  List<Object?> get props => [name, filter, sort];
}

class AggregateGroupSearch {
  AggregateGroupSearch({this.filter = const [], this.size, this.sort});

  List<FilterDTO>? filter;

  /// Minimum value: 0
  int? size;

  List<AggregateGroupSortDTO>? sort;
}

class AggregateSearch {
  AggregateSearch({this.filter = const []});

  List<FilterDTO>? filter;
}
