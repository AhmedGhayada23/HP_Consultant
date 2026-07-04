import 'package:hb/core/data/datasource/hb_lab_project_data_source.dart';
import 'package:hb/core/data/models/hb_lab_project_model.dart';

abstract class HbLabProjectRepository {
  Future<HbLabProjectPageResponse> getHbLabProject({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  });
}

class HbLabProjectRepositoryImpl extends HbLabProjectRepository {
  final HbLabProjectDataSource dataSource;
  HbLabProjectRepositoryImpl(this.dataSource);

  @override
  Future<HbLabProjectPageResponse> getHbLabProject({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  }) {
    return dataSource.getHbLabProject(
      search: search,
      page: page,
      filters: filters,
    );
  }
}
