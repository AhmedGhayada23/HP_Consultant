import 'package:hb/core/data/models/details_hb_lab_project_model.dart';
import 'package:hb/core/domain/repository/details_hb_lab_project_repository.dart';

class DetailsHbLabProjectUsecase {
  final DetailsHbLabProjectRepository repository;
  DetailsHbLabProjectUsecase(this.repository);

  Future<DetailsHbLabProjectModel> call(int id) {
    return repository.getDetailsHbLabProject(id);
  }
}
