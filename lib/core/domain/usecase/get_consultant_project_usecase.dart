import 'package:flutter/material.dart';
import 'package:hb/core/data/models/consultant_project_model.dart';
import 'package:hb/core/domain/repository/consultant_project_repository.dart';

class GetConsultantProjectUsecase {
  final ConsultantProjectRepository consultantProjectRepository;

  GetConsultantProjectUsecase(this.consultantProjectRepository);

  Future<List<ConsultantProjectModel>> call({String? search, String? status, String? project, String? role}) async {
    return consultantProjectRepository.getConsultantProject(search: search, status: status, project: project, role: role);
  }

  Future<void> addProject({BuildContext? context, required Map<String, dynamic> projectData}) {
    return consultantProjectRepository.addProject(context: context, projectData: projectData);
  }

  Future<void> updateProject({
    BuildContext? context,
    required int projectId,
    required Map<String, dynamic> projectData,
  }) async {
    return consultantProjectRepository.updateProject(
      projectId: projectId,
      projectData: projectData,
    );
  }
}
