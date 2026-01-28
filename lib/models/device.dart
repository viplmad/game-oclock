import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const Device({required this.id, required this.name, required this.imageUrl});

  @override
  List<Object?> get props => [id];
}
