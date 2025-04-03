import 'package:equatable/equatable.dart';

/// Base event class for authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check if the user is authenticated
class CheckAuthStatusEvent extends AuthEvent {}

/// Login event with credentials
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register event with details
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String? name;
  final String? phone;

  const RegisterEvent({
    required this.email,
    required this.password,
    this.name,
    this.phone,
  });

  @override
  List<Object?> get props => [email, password, name, phone];
}

/// Logout event
class LogoutEvent extends AuthEvent {}
