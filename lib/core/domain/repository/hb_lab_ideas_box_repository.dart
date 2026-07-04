import 'package:hb/core/data/datasource/hb_lab_ideas_box_data_source.dart';
import 'package:hb/core/data/models/hb_lab_ideas_box_model.dart';

abstract class HbLabIdeasBoxRepository {
  Future<HbLabIdeasPageResponse> getHbLabIdeasBox({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  });
}

class HbLabIdeasBoxRepositoryImpl extends HbLabIdeasBoxRepository {
  final HbLabIdeasBoxDataSource dataSource;
  HbLabIdeasBoxRepositoryImpl(this.dataSource);

  @override
  Future<HbLabIdeasPageResponse> getHbLabIdeasBox({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  }) {
    return dataSource.getHbLabIdeasBox(
      search: search,
      page: page,
      filters: filters,
    );
  }
}
