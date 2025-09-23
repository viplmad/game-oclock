import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final List<String> roles;

  const User({required this.id, required this.username, this.roles = const []});

  @override
  List<Object?> get props => [id, username];
}
