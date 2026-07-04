import 'package:flutter/material.dart';
import 'package:hb/core/data/models/assign_consultant_model.dart';
import 'package:hb/core/domain/repository/assign_consultant_repository.dart';

class AssignConsultantUsecase {

  final AssignConsultantRepository _repository;

  AssignConsultantUsecase(this._repository);

  Future<void> assignConsultant(BuildContext context,int projectId, AssignConsultantModel model) {
    return _repository.assignConsultant(context,projectId, model);
  }
}
