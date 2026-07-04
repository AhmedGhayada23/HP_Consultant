import 'package:flutter/material.dart';
import 'package:hb/core/data/datasource/assign_consultant_remote_data_source.dart';
import 'package:hb/core/data/models/assign_consultant_model.dart';

abstract class AssignConsultantRepository {
  Future<void> assignConsultant(BuildContext context,int projectId, AssignConsultantModel model);
}

class AssignConsultantRepositoryImpl implements AssignConsultantRepository {

  final AssignConsultantRemoteDataSource _dataSource;

  AssignConsultantRepositoryImpl(this._dataSource);

  @override
  Future<void> assignConsultant(BuildContext context,int projectId, AssignConsultantModel model) {
    return _dataSource.assignConsultant(context,projectId, model);
  }
}
