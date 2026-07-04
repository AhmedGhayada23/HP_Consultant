// lib/featuer/career_opportunities/domain/repositories/my_application_repository.dart

import 'package:hb/core/data/datasource/my_application_remote_datasource.dart';
import '../../data/models/my_application_model.dart';

abstract class MyApplicationRepository {
  Future<List<MyApplicationModel>> getMyApplications();
}

class MyApplicationRepositoryImpl extends MyApplicationRepository {
  final MyApplicationRemoteDataSource remoteDataSource;

  MyApplicationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MyApplicationModel>> getMyApplications() async {
    return await remoteDataSource.getMyApplications();
  }
}
