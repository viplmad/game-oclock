import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final String host;
  final String username;
  final String password;

  const Login({
    required this.host,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [host, username];
}
