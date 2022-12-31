import 'dart:convert';

import 'package:challenge2/core/utils/refresh_token_interceptor.dart';

import '../../di/injection.dart';
import '../data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const userData = 'User';
  static const isLogin = 'isLogin';

  saveLoginData(User? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userData, json.encode(value));
    prefs.setBool(isLogin, true);
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userData);
    prefs.setBool(isLogin, false);
    await getIt<RefreshTokenInterceptor>().removeToken();
    if (prefs.getBool(isLogin) == null) {
      return false;
    } else {
      return await getLoginState();
    }
  }

  Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(isLogin) == null) {
      return false;
    } else {
      return prefs.getBool(isLogin)!;
    }
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(userData) != null) {
      return User.fromJson(json.decode(prefs.getString(userData)!));
    } else {
      return null;
    }
  }
}
