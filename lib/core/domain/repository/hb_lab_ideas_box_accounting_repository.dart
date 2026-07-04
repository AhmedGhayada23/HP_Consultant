import 'package:hb/core/data/datasource/hb_lab_ideas_box_accounting_data_source.dart';
import 'package:hb/core/data/models/hb_lab_ideas_box_model.dart';

abstract class HbLabIdeasBoxAccountingRepository {
  Future<HbLabIdeasPageResponse> getHbLabIdeasBox({
    String? search,
    int page,
    Map<String, dynamic>? filters,
  });
}

class HbLabIdeasBoxAccountingRepositoryImpl
    extends HbLabIdeasBoxAccountingRepository {
  final HbLabIdeasBoxAccountingDataSource dataSource;
  HbLabIdeasBoxAccountingRepositoryImpl(this.dataSource);

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
