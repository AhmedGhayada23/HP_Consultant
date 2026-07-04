// lib/featuer/user_home/accounting_clint_home/domain/repositories/accounting_request_repository.dart

import 'package:hb/core/data/datasource/accounting_request_remote_datasource.dart';

import '../../data/models/accounting_request_model.dart';

abstract class AccountingRequestRepository {
  Future<List<AccountingRequestModel>> getServiceRequests();
}

class AccountingRequestRepositoryImpl extends AccountingRequestRepository {
  final AccountingRequestRemoteDataSource remoteDataSource;

  AccountingRequestRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AccountingRequestModel>> getServiceRequests() async {
    return await remoteDataSource.getServiceRequests();
  }
}
