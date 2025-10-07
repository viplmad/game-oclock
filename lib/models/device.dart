import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String id;
  final String name;

  const Device({required this.id, required this.name});

  @override
  List<Object?> get props => [id];
}
