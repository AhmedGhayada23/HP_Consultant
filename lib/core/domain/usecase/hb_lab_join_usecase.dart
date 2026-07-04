import 'package:flutter/widgets.dart';
import 'package:hb/core/domain/repository/hb_lab_join_repository.dart';

class HbLabJoinUsecase {
  final HbLabJoinRepository repository;
  HbLabJoinUsecase(this.repository);

  Future<bool> call({
    required BuildContext context,
    required int projectId,
    required String message,
    required String expertise,
  }) {
    return repository.joinProject(
      context: context,
      projectId: projectId,
      message: message,
      expertise: expertise,
    );
  }
}
