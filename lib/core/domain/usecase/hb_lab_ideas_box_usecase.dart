import 'package:hb/core/data/models/hb_lab_ideas_box_model.dart';
import 'package:hb/core/domain/repository/hb_lab_ideas_box_repository.dart';

class HbLabIdeasBoxUsecase {
  final HbLabIdeasBoxRepository repository;
  HbLabIdeasBoxUsecase(this.repository);

  Future<HbLabIdeasPageResponse> call({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  }) {
    return repository.getHbLabIdeasBox(
      search: search,
      page: page,
      filters: filters,
    );
  }
}
