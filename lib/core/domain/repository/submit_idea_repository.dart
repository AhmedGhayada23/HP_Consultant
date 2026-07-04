import 'package:flutter/widgets.dart';
import 'package:hb/core/data/datasource/submit_idea_datasource.dart';

abstract class SubmitIdeaRepository {
  Future<bool> submitIdea({
    required BuildContext context,
    required String title,
    required String description,
    required String confidentialityLevel,
    required List<String> tags,
    String? attachmentPath,
  });
}

class SubmitIdeaRepositoryImpl extends SubmitIdeaRepository {
  final SubmitIdeaDataSource dataSource;
  SubmitIdeaRepositoryImpl(this.dataSource);

  @override
  Future<bool> submitIdea({
    required BuildContext context,
    required String title,
    required String description,
    required String confidentialityLevel,
    required List<String> tags,
    String? attachmentPath,
  }) {
    return dataSource.submitIdea(
      context: context,
      title: title,
      description: description,
      confidentialityLevel: confidentialityLevel,
      tags: tags,
      attachmentPath: attachmentPath,
    );
  }
}
