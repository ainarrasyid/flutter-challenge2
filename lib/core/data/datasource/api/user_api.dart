import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import '../../model/api_response.dart';
import '../../model/user.dart';
part '../../../../gen/core/data/datasource/api/user_api.g.dart';

@RestApi()
@Injectable() // dependensi yang diperlukan oleh kelas dengan anotasi injectable akan diresolve otomatis
abstract class UserApi {
  @factoryMethod // diperlukan anotasi factoryMethod jika objek dibuat menggunakan factory
  factory UserApi(Dio dio) = _UserApi;

  @GET('/user/get-token')
  Future<ApiResponse> getToken();

  @GET('/user/refresh-token')
  Future<ApiResponse<User>> refreshToken();

  @POST('/user')
  @FormUrlEncoded()
  Future<ApiResponse> register(
    @Field('name') String name,
    @Field('email') String email,
    @Field('password') String password,
  );

  @POST('/user/login')
  @FormUrlEncoded()
  Future<ApiResponse<User>> login(
    @Field('email') String email,
    @Field('password') String password,
  );

  @GET('/user/profile')
  Future<ApiResponse<User>> getUser();

  @PATCH('/user/profile')
  @MultiPart()
  Future<ApiResponse<User>> updateUser(
    @Part(name: 'name') String name,
    @Part(name: 'photo') File photo,
  );
}
