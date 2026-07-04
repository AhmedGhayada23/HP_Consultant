import 'package:hb/core/data/datasource/reject_application_data_source.dart';

abstract class RejectApplicationRepository {
  Future<void> rejectApplication(int applicationId);
}

class RejectApplicationRepositoryImpl extends RejectApplicationRepository {
  final RejectApplicationDataSource dataSource;
  RejectApplicationRepositoryImpl(this.dataSource);

  @override
  Future<void> rejectApplication(int applicationId) {
    return dataSource.rejectApplication(applicationId);
  }
}
