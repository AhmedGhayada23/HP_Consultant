import 'package:hb/core/domain/repository/hb_lab_comment_repository.dart';

class HbLabCommentUsecase {
  final HbLabCommentRepository repository;
  HbLabCommentUsecase(this.repository);

  Future<bool> call({required int ideaId, required String body}) {
    return repository.addComment(ideaId: ideaId, body: body);
  }
}
