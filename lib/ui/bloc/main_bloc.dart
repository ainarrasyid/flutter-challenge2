import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc/bloc.dart';
import 'package:challenge2/core/data/datasource/api/user_api.dart';
import '../../core/data/model/user.dart';
import '../../core/utils/dio_error_wrapper.dart';
import '../../core/utils/shared_preferences.dart';
import '../../core/utils/status.dart';

part 'main_event.dart';
part 'main_state.dart';

@injectable
class MainBloc extends Bloc<MainEvent, MainState> {
  final UserApi api;
  SharedPref sharedPref = SharedPref();

  String? email;
  String? password;
  User? user;

  MainBloc(this.api) : super(MainInitial()) {
    on<Login>((event, emit) async {
      emit(const LoginResultState(status: Status.loading));
      try {
        final response = await api.login(email!, password!);
        user = response.data;
        emit(LoginResultState(
            status: Status.success, message: response.message, data: user));

        SharedPref().saveLoginData(user);
      } catch (e) {
        if (e is DioErrorWrapper) {
          emit(LoginResultState(status: Status.error, message: e.message));
        } else {
          emit(const LoginResultState(
              status: Status.error, message: 'Unknown Error'));
        }
      }
    });

    on<Register>((event, emit) async {
      emit(const RegisterResultState(status: Status.loading));
      try {
        final response =
            await api.register(event.name, event.email, event.password);
        emit(RegisterResultState(
            status: Status.success, message: response.message));
      } catch (e) {
        log(e.toString());
        if (e is DioErrorWrapper) {
          if (e.message.contains('already_exists')) {
            emit(const RegisterResultState(
                status: Status.error, message: 'User already exist'));
          } else {
            emit(RegisterResultState(
                status: Status.error, message: e.message.toString()));
          }
        } else {
          log(e.toString());
          emit(const RegisterResultState(
              status: Status.error, message: 'Unknown Error'));
        }
      }
    });

    on<GetUser>((event, emit) async {
      final isLogin = await sharedPref.getLoginState();

      emit(const LoginResultState(status: Status.loading));
      if (isLogin) {
        if (user != null) {
          emit(LoginResultState(
              status: Status.success, data: user, isLogin: isLogin));
        } else {
          try {
            final response = await api.getUser();
            user = response.data;
            SharedPref().saveLoginData(user);

            emit(LoginResultState(
                status: Status.success, data: user, isLogin: true));
          } catch (e) {
            if (e is DioErrorWrapper) {
              emit(LoginResultState(
                  status: Status.error, message: e.message, isLogin: false));
            } else {
              emit(LoginResultState(
                  status: Status.error, message: e.toString(), isLogin: false));
            }
          }
        }
      } else {
        emit(const LoginResultState(status: Status.success, isLogin: false));
      }
    });

    on<UpdateUser>((event, emit) async {
      emit(const LoginResultState(status: Status.loading));
      try {
        final response = await api.updateUser(event.name, event.photo);
        emit(LoginResultState(
            status: Status.success,
            data: response.data,
            message: response.message));
      } catch (e) {
        log(e.toString());
        if (e is DioErrorWrapper) {
          emit(LoginResultState(
              status: Status.error, message: e.message.toString()));
        } else {
          log(e.toString());
          emit(const LoginResultState(
              status: Status.error, message: 'Unknown Error'));
        }
      }
    });

    on<Logout>((event, emit) async {
      emit(const LogoutResultState(status: Status.loading));
      if (!await sharedPref.logout()) {
        emit(const LogoutResultState(status: Status.success));
      } else {
        emit(const LogoutResultState(status: Status.error));
      }
    });
  }

  loadSharedPref() async {
    try {
      user = await sharedPref.getUser();
    } catch (e) {
      user = null;
    }
  }
}
