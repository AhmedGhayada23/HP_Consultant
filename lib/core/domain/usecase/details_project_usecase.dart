import 'package:flutter/material.dart';
import 'package:hb/core/data/models/details_project_model.dart';
import 'package:hb/core/domain/repository/details_project_repository.dart';

class DetailsProjectUsecase {
  final DetailsProjectRepository repository;
  DetailsProjectUsecase(this.repository);

  Future<DetailsProjectModel> call(int id) async {
    return await repository.getDetailsProject(id);
  }

  Future<void> closeProject(BuildContext context, int id) async {
    return await repository.closeProject(context, id);
  }
}
