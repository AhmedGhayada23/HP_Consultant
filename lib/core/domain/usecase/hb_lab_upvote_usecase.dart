import 'package:hb/core/data/datasource/hb_lab_upvote_datasource.dart';
import 'package:hb/core/domain/repository/hb_lab_upvote_repository.dart';

class HbLabUpvoteUsecase {
  final HbLabUpvoteRepository repository;
  HbLabUpvoteUsecase(this.repository);

  Future<UpvoteResult> call(int id) {
    return repository.toggleUpvote(id);
  }
}
