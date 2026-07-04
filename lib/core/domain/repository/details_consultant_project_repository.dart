import 'package:hb/core/data/datasource/details_consultant_project_data_source.dart';
import 'package:hb/core/data/models/details_consultant_project_model.dart';

abstract class DetailsConsultantProjectRepository {
 Future<DetailsConsultantProjectModel> getDetailsConsultantProject(int id);
}

class DetailsConsultantProjectRepositoryImpl extends DetailsConsultantProjectRepository {
  final DetailsConsultantProjectDataSource dataSource;
  DetailsConsultantProjectRepositoryImpl(this.dataSource);

  @override
  Future<DetailsConsultantProjectModel> getDetailsConsultantProject(int id) {
    return dataSource.getDetailsConsultantProject(id);
  }
}
