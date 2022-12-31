part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class Login extends MainEvent {
  const Login();

  @override
  List<Object> get props => [];
}

class GetUser extends MainEvent {
  const GetUser();

  @override
  List<Object> get props => [];
}

class Register extends MainEvent {
  final String name;
  final String email;
  final String password;

  const Register(
      {required this.name, required this.email, required this.password});

  @override
  List<Object> get props => [name, email, password];
}

class UpdateUser extends MainEvent {
  final String name;
  final File photo;

  const UpdateUser({required this.name, required this.photo});

  @override
  List<Object> get props => [name, photo];
}

class Logout extends MainEvent {
  const Logout();

  @override
  List<Object> get props => [];
}
