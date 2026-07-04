import 'package:hb/core/data/datasource/details_hb_lab_project_data_source.dart';
import 'package:hb/core/data/models/details_hb_lab_project_model.dart';

abstract class DetailsHbLabProjectRepository {
  Future<DetailsHbLabProjectModel> getDetailsHbLabProject(int id);
}

class DetailsHbLabProjectRepositoryImpl extends DetailsHbLabProjectRepository {
  final DetailsHbLabProjectDataSource dataSource;
  DetailsHbLabProjectRepositoryImpl(this.dataSource);

  @override
  Future<DetailsHbLabProjectModel> getDetailsHbLabProject(int id) {
    return dataSource.getDetailsHbLabProject(id);
  }
}
