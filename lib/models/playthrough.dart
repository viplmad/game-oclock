import 'package:equatable/equatable.dart';

class Playthrough extends Equatable {
  final String id;
  final String name;

  const Playthrough({required this.id, required this.name});

  @override
  List<Object?> get props => [name];
}
