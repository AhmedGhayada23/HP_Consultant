import 'package:flutter/widgets.dart';
import 'package:hb/core/data/datasource/hb_lab_join_datasource.dart';

abstract class HbLabJoinRepository {
  Future<bool> joinProject({
    required BuildContext context,
    required int projectId,
    required String message,
    required String expertise,
  });
}

class HbLabJoinRepositoryImpl implements HbLabJoinRepository {
  final HbLabJoinDataSource dataSource;
  HbLabJoinRepositoryImpl(this.dataSource);

  @override
  Future<bool> joinProject({
    required BuildContext context,
    required int projectId,
    required String message,
    required String expertise,
  }) {
    return dataSource.joinProject(
      context: context,
      projectId: projectId,
      message: message,
      expertise: expertise,
    );
  }
}
