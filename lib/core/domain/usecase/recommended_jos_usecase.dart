import 'package:hb/core/data/models/recommended_jos_model.dart';
import 'package:hb/core/domain/repository/recommended_jos_repository.dart';

class RecommendedJosUsecase {
  final RecommendedJosRepository repository;

  RecommendedJosUsecase(this.repository);

  Future<JobsPageResponse> call({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  }) {
    return repository.getRecommendedJob(
      search: search,
      page: page,
      filters: filters,
    );
  }
}
