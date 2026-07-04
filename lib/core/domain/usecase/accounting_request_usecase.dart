import 'package:hb/core/data/models/accounting_request_model.dart';
import 'package:hb/core/domain/repository/accounting_request_repository.dart';

class AccountingRequestUsecase {
  final AccountingRequestRepository repository;
  AccountingRequestUsecase(this.repository);

  Future<List<AccountingRequestModel>> call() async {
    return await repository.getServiceRequests();
  }
}
