import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String id;
  final String name;
  final String iconUrl;

  const Device({required this.id, required this.name, required this.iconUrl});

  @override
  List<Object?> get props => [id];
}
