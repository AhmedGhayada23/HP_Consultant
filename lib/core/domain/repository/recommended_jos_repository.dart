import 'package:hb/core/data/datasource/recommended_jos_data_source.dart';
import 'package:hb/core/data/models/recommended_jos_model.dart';

abstract class RecommendedJosRepository {
  Future<JobsPageResponse> getRecommendedJob({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  });
}

class RecommendedJosRepositoryImpl extends RecommendedJosRepository {
  final RecommendedJosDataSource dataSource;
  RecommendedJosRepositoryImpl(this.dataSource);

  @override
  Future<JobsPageResponse> getRecommendedJob({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  }) {
    return dataSource.getRecommendedJob(
      search: search,
      page: page,
      filters: filters,
    );
  }
}
