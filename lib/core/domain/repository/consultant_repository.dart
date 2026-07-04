// lib/featuer/counsultants_directory/domain/repositories/consultant_repository.dart
import 'package:hb/core/data/datasource/consultant_remote_datasource.dart';
import 'package:hb/core/data/models/consultant_category_model.dart';
import 'package:hb/core/data/models/consultant_profile_details_model.dart';
import '../../data/models/consultant_model.dart';

abstract class ConsultantRepository {
  Future<List<ConsultantModel>> getConsultants({
    String? search,
    String? category,
    String? minBudget,
    String? maxBudget,
    String? availability,
    int perPage,
    int page,
  });
  Future<ConsultantProfileDetailsModel> getConsultantDetails(int id);
  Future<List<ConsultantCategoryModel>> getConsultantCategories();
  Future<String> getConsultantCvUrl(int id, {bool directory});
}

class ConsultantRepositoryImpl extends ConsultantRepository {
  final ConsultantRemoteDataSource remoteDataSource;

  ConsultantRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ConsultantModel>> getConsultants({
    String? search,
    String? category,
    String? minBudget,
    String? maxBudget,
    String? availability,
    int perPage = 12,
    int page = 1,
  }) {
    return remoteDataSource.getConsultants(
      search: search,
      category: category,
      minBudget: minBudget,
      maxBudget: maxBudget,
      availability: availability,
      perPage: perPage,
      page: page,
    );
  }

  @override
  Future<ConsultantProfileDetailsModel> getConsultantDetails(int id) =>
      remoteDataSource.getConsultantDetails(id);

  @override
  Future<List<ConsultantCategoryModel>> getConsultantCategories() =>
      remoteDataSource.getConsultantCategories();

  @override
  Future<String> getConsultantCvUrl(int id, {bool directory = true}) =>
      remoteDataSource.getConsultantCvUrl(id, directory: directory);
}
