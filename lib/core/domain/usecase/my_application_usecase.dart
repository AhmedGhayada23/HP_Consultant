import 'package:hb/core/data/models/my_application_model.dart';
import 'package:hb/core/domain/repository/my_application_repository.dart';

class MyApplicationUsecase {
  final MyApplicationRepository repository;

  MyApplicationUsecase(this.repository);

  Future<List<MyApplicationModel>> call() async {
    return await repository.getMyApplications();
  }
}
