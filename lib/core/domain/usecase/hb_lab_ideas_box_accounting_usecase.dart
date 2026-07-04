import 'package:hb/core/data/models/hb_lab_ideas_box_model.dart';
import 'package:hb/core/domain/repository/hb_lab_ideas_box_accounting_repository.dart';

class HbLabIdeasBoxAccountingUsecase {
  final HbLabIdeasBoxAccountingRepository repository;
  HbLabIdeasBoxAccountingUsecase(this.repository);

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
