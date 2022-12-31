part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object?> get props => [];
}

class MainInitial extends MainState {}

class LoginResultState extends MainState {
  final Status status;
  final String? message;
  final User? data;
  final bool? isLogin;

  const LoginResultState(
      {required this.status, this.message, this.data, this.isLogin});

  @override
  List<Object?> get props => [status, message, data, isLogin];
}

class TokenResultState extends MainState {
  final Status status;
  final String? message;
  final User? data;

  const TokenResultState({required this.status, this.message, this.data});

  @override
  List<Object?> get props => [status, message, data];
}

class RegisterResultState extends MainState {
  final Status status;
  final String? message;
  const RegisterResultState({required this.status, this.message});

  @override
  List<Object?> get props => [status, message];
}

class LogoutResultState extends MainState {
  final Status status;
  const LogoutResultState({required this.status});

  @override
  List<Object?> get props => [status];
}
