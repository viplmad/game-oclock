import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final String id;
  final String name;

  const Tag({required this.id, required this.name});

  @override
  List<Object?> get props => [id];
}
