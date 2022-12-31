import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import '../../model/api_response.dart';
import '../../model/note.dart';

part '../../../../gen/core/data/datasource/api/notes_api.g.dart';

@RestApi()
@Injectable()
abstract class NoteApi {
  @factoryMethod
  factory NoteApi(Dio dio) = _NoteApi;

  @GET('/note')
  Future<ApiResponse<List<Note>>> getNote();

  @POST('/note')
  @FormUrlEncoded()
  Future<ApiResponse> createNote(
    @Field('title') String title,
    @Field('content') String content,
  );

  @PATCH('/note/{id}')
  @FormUrlEncoded()
  Future<ApiResponse> updateNote(
    @Path('id') String id,
    @Field('title') String title,
    @Field('content') String content,
  );

  @DELETE('/note/{id}')
  @FormUrlEncoded()
  Future<ApiResponse> deleteNote(
    @Path('id') String id,
  );
}
