import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignUp({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  const AuthSignIn({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthSignOut extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}
