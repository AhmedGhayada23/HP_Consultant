import 'package:flutter/widgets.dart';
import 'package:hb/core/domain/repository/boost_project_repository.dart';

class BoostProjectUsecase {
  final BoostProjectRepository repository;
  BoostProjectUsecase(this.repository);

  Future<bool> call({
    required BuildContext context,
    required String title,
    required List<String> categoryTags,
    required String budget,
    required String deadline,
    required String description,
    required String goalsDeliverables,
    String? attachmentPath,
  }) {
    return repository.boostProject(
      context: context,
      title: title,
      categoryTags: categoryTags,
      budget: budget,
      deadline: deadline,
      description: description,
      goalsDeliverables: goalsDeliverables,
      attachmentPath: attachmentPath,
    );
  }
}
