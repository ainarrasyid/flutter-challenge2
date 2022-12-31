import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part '../../../gen/core/data/model/user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'photo')
  final String? photo;

  const User({this.id, this.name, this.email, this.photo});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, name, email, photo];
}
