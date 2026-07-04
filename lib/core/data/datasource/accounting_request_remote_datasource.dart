// lib/featuer/user_home/accounting_clint_home/data/datasources/accounting_request_remote_datasource.dart

import 'dart:async';
import '../models/accounting_request_model.dart';

abstract class AccountingRequestRemoteDataSource {
  Future<List<AccountingRequestModel>> getServiceRequests();
}

class AccountingRequestRemoteDataSourceImpl extends AccountingRequestRemoteDataSource {
  @override
  Future<List<AccountingRequestModel>> getServiceRequests() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate API call

    return [
      AccountingRequestModel(
        id: '1',
        title: 'Tax Filing',
        requestId: 'SR-2025-001',
        dateSubmitted: '15 Sept 2025',
        assignedTo: 'John Doe',
        budget: '€1,200',
        status: 'In Progress',
      ),
      AccountingRequestModel(
        id: '2',
        title: 'Payroll Management',
        requestId: 'SR-2025-002',
        dateSubmitted: '02 Oct 2025',
        assignedTo: 'Sarah Smith',
        budget: '€2,000',
        status: 'Pending',
      ),
    ];
  }
}
