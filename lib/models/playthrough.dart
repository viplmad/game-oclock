import 'package:equatable/equatable.dart';

import 'fields.dart';
import 'nav_destination.dart';

class NewPlaythrough extends Equatable {
  final String name;

  const NewPlaythrough({required this.name});

  @override
  List<Object?> get props => [name];
}

class Playthrough extends Equatable {
  final String id;
  final String name;

  const Playthrough({required this.id, required this.name});

  @override
  List<Object?> get props => [name];
}

final List<OptionTextField<String>> playthroughFieldOptions = List.unmodifiable(
  <OptionTextField<String>>[
    idField,
    nameField,
    imageField,
    addedDatetimeField,
    updatedDatetimeField,
  ],
);
