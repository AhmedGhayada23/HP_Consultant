import 'package:hb/core/data/models/details_application_model.dart';
import 'package:hb/core/domain/repository/details_application_repository.dart';

class GetDetailsApplicationUsecase {
  final DetailsApplicationRepository repository;

  GetDetailsApplicationUsecase(this.repository);

  Future<DetailsApplicationModel> call(int applicationId) async{
    return repository.getDetailsApplication(applicationId);
  }
}
