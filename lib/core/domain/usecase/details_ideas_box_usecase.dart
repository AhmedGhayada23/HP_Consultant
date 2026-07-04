import 'package:hb/core/data/models/details_ideas_box_model.dart';
import 'package:hb/core/domain/repository/details_ideas_box_repository.dart';

class DetailsIdeasBoxUsecase {
  final DetailsIdeasBoxRepository repository;
  DetailsIdeasBoxUsecase(this.repository);

  Future<DetailsIdeasBoxModel> call(int id) {
    return repository.getDetailsIdeasBox(id);
  }
}
