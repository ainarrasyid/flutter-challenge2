// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../core/data/model/api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      json['status'] as int? ?? 0,
      json['message'] as String? ?? 'message',
      json['error'] as String?,
      fromJsonT(json['data']),
      json['token'] as String?,
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'error': instance.error,
      'token': instance.token,
      'data': toJsonT(instance.data),
    };
