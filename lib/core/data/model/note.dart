import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../../gen/core/data/model/note.g.dart';

@JsonSerializable()
class Note extends Equatable {
  final String? id;
  final String? title;
  final String? content;
  @JsonKey(name: 'created_at')
  final int? createdAt;
  @JsonKey(name: 'updated_at')
  final int? updatedAt;

  const Note({
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  @override
  List<Object?> get props => [id, title, content, createdAt, updatedAt];
}
