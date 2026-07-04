import 'package:hb/core/data/datasource/hb_lab_comment_datasource.dart';

abstract class HbLabCommentRepository {
  Future<bool> addComment({required int ideaId, required String body});
}

class HbLabCommentRepositoryImpl extends HbLabCommentRepository {
  final HbLabCommentDataSource dataSource;
  HbLabCommentRepositoryImpl(this.dataSource);

  @override
  Future<bool> addComment({required int ideaId, required String body}) {
    return dataSource.addComment(ideaId: ideaId, body: body);
  }
}
