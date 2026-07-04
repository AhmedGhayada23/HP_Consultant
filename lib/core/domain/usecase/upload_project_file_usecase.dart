import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hb/core/domain/repository/project_file_repository.dart';

class UploadProjectFileUseCase {
  final ProjectFileRepository _repository;
  UploadProjectFileUseCase(this._repository);

  Future<void> call({
    required BuildContext context,
    required int projectId,
    required File file,
    required String fileType,
  }) async {
    return await _repository.uploadFile(context: context,projectId: projectId, file: file, fileType: fileType);
  }

  Future<void> uploadDeliverables({
    required int projectId,
    required int milestoneId,
    required bool markCompleted,
    required File file,
  }) async {
    return await _repository.uploadDeliverables(
      projectId: projectId,
      milestoneId: milestoneId,
      markCompleted: markCompleted,
      file: file,
    );
  }
}
