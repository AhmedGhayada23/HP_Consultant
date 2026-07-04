import 'package:flutter/material.dart';
import 'package:hb/core/data/datasource/consultant_project_remote_datasouce.dart';
import 'package:hb/core/data/models/consultant_project_model.dart';

abstract class ConsultantProjectRepository {
  Future<List<ConsultantProjectModel>> getConsultantProject({String? search, String? status, String? project, String? role});
  Future<void> addProject({BuildContext? context, required Map<String, dynamic> projectData});
  Future<void> updateProject({
    BuildContext? context,
    required int projectId,
    required Map<String, dynamic> projectData,
  });
}

class ConsultantProjectRepositoryImpl extends ConsultantProjectRepository {
  final ConsultantProjectRemoteDatasouce consultantProjectRemoteDatasouce;

  ConsultantProjectRepositoryImpl(this.consultantProjectRemoteDatasouce);

  @override
  Future<List<ConsultantProjectModel>> getConsultantProject({String? search, String? status, String? project, String? role}) {
    return consultantProjectRemoteDatasouce.getConsultantProject(search: search, status: status, project: project, role: role);
  }

  @override
  Future<void> addProject({BuildContext? context, required Map<String, dynamic> projectData}) {
    return consultantProjectRemoteDatasouce.addProject(context: context, projectData: projectData);
  }

  @override
  Future<void> updateProject({
    BuildContext? context,
    required int projectId,
    required Map<String, dynamic> projectData,
  }) {
    return consultantProjectRemoteDatasouce.updateProject(
      projectId: projectId,
      projectData: projectData,
    );
  }
}
