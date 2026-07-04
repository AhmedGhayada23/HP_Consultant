import 'package:hb/core/data/models/details_consultant_project_model.dart';
import 'package:hb/core/domain/repository/details_consultant_project_repository.dart';

class DetailsConsultantProjectUsecase {
  final DetailsConsultantProjectRepository repository;

  DetailsConsultantProjectUsecase(this.repository);

  Future<DetailsConsultantProjectModel> call(int id) async {
    return await repository.getDetailsConsultantProject(id);
  }
}
