import 'package:hb/core/domain/repository/reject_application_repository.dart';

class RejectApplicationUsecase {
  final RejectApplicationRepository repository;
  RejectApplicationUsecase(this.repository);

  Future<void> call(int applicationId) {
    return repository.rejectApplication(applicationId);
  }
}
