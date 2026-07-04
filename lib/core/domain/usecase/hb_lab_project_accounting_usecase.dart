import 'package:hb/core/data/models/hb_lab_project_model.dart';
import 'package:hb/core/domain/repository/hb_lab_project_accounting_repository.dart';

class HbLabProjectAccountingUsecase {
  final HbLabProjectAccountingRepository repository;
  HbLabProjectAccountingUsecase(this.repository);

  Future<HbLabProjectPageResponse> call({
    String? search,
    int page = 1,
    Map<String, dynamic>? filters,
  }) {
    return repository.getHbLabProject(
      search: search,
      page: page,
      filters: filters,
    );
  }
}
