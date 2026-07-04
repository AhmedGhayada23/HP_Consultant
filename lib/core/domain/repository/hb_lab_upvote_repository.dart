import 'package:hb/core/data/datasource/hb_lab_upvote_datasource.dart';

abstract class HbLabUpvoteRepository {
  Future<UpvoteResult> toggleUpvote(int id);
}

class HbLabUpvoteRepositoryImpl extends HbLabUpvoteRepository {
  final HbLabUpvoteDataSource dataSource;
  HbLabUpvoteRepositoryImpl(this.dataSource);

  @override
  Future<UpvoteResult> toggleUpvote(int id) {
    return dataSource.toggleUpvote(id);
  }
}
