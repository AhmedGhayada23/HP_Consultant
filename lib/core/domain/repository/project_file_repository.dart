import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hb/core/data/datasource/project_file_remote_data_source.dart';

abstract class ProjectFileRepository {
  Future<void> uploadFile({
    required BuildContext context,
    required int projectId,
    required File file,
    required String fileType,
  });

  Future<void> uploadDeliverables({
    required int projectId,
    required int milestoneId,
    required bool markCompleted,
    required File file,
  });
}

class ProjectFileRepositoryImpl extends ProjectFileRepository {
  final ProjectFileRemoteDataSource _dataSource;
  ProjectFileRepositoryImpl(this._dataSource);

  @override
  Future<void> uploadFile({
    required BuildContext context,
    required int projectId,
    required File file,
    required String fileType,
  }) {
    return _dataSource.uploadFile(context: context,projectId: projectId, file: file, fileType: fileType);
  }

  @override
  Future<void> uploadDeliverables({
    required int projectId,
    required int milestoneId,
    required bool markCompleted,
    required File file,
  }) {
    return _dataSource.uploadDeliverables(
      projectId: projectId,
      milestoneId: milestoneId,
      markCompleted: markCompleted,
      file: file,
    );
  }
}
