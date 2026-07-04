import 'package:hb/core/data/models/consultant_category_model.dart';
import 'package:hb/core/data/models/consultant_model.dart';
import 'package:hb/core/data/models/consultant_profile_details_model.dart';
import 'package:hb/core/domain/repository/consultant_repository.dart';

class ConsultantUsecase {
  final ConsultantRepository repository;

  ConsultantUsecase(this.repository);

  Future<List<ConsultantModel>> call({
    String? search,
    String? category,
    String? minBudget,
    String? maxBudget,
    String? availability,
    int perPage = 12,
    int page = 1,
  }) {
    return repository.getConsultants(
      search: search,
      category: category,
      minBudget: minBudget,
      maxBudget: maxBudget,
      availability: availability,
      perPage: perPage,
      page: page,
    );
  }
}

class ConsultantCategoriesUsecase {
  final ConsultantRepository repository;

  ConsultantCategoriesUsecase(this.repository);

  Future<List<ConsultantCategoryModel>> call() =>
      repository.getConsultantCategories();
}

class ConsultantDetailsUsecase {
  final ConsultantRepository repository;

  ConsultantDetailsUsecase(this.repository);

  Future<ConsultantProfileDetailsModel> call(int id) =>
      repository.getConsultantDetails(id);
}

class ConsultantCvUsecase {
  final ConsultantRepository repository;

  ConsultantCvUsecase(this.repository);

  Future<String> call(int id, {bool directory = true}) =>
      repository.getConsultantCvUrl(id, directory: directory);
}
