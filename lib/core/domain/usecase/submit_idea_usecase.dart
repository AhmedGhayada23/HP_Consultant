import 'package:flutter/widgets.dart';
import 'package:hb/core/domain/repository/submit_idea_repository.dart';

class SubmitIdeaUsecase {
  final SubmitIdeaRepository repository;
  SubmitIdeaUsecase(this.repository);

  Future<bool> call({
    required BuildContext context,
    required String title,
    required String description,
    required String confidentialityLevel,
    required List<String> tags,
    String? attachmentPath,
  }) {
    return repository.submitIdea(
      context: context,
      title: title,
      description: description,
      confidentialityLevel: confidentialityLevel,
      tags: tags,
      attachmentPath: attachmentPath,
    );
  }
}
