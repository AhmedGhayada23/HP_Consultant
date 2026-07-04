import 'package:flutter/widgets.dart';
import 'package:hb/core/data/datasource/boost_project_datasource.dart';

abstract class BoostProjectRepository {
  Future<bool> boostProject({
    required BuildContext context,
    required String title,
    required List<String> categoryTags,
    required String budget,
    required String deadline,
    required String description,
    required String goalsDeliverables,
    String? attachmentPath,
  });
}

class BoostProjectRepositoryImpl implements BoostProjectRepository {
  final BoostProjectDataSource dataSource;
  BoostProjectRepositoryImpl(this.dataSource);

  @override
  Future<bool> boostProject({
    required BuildContext context,
    required String title,
    required List<String> categoryTags,
    required String budget,
    required String deadline,
    required String description,
    required String goalsDeliverables,
    String? attachmentPath,
  }) {
    return dataSource.boostProject(
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
