import 'package:hb/core/data/models/details_my_application_model.dart';
import 'package:hb/core/domain/repository/details_my_application_repository.dart';

class DetailsMyApplicationUsecase {
  final DetailsMyApplicationRepository repository;
  DetailsMyApplicationUsecase(this.repository);

  Future<DetailsMyApplicationModel> call(int applicationId) {
    return repository.getDetails(applicationId);
  }
}
