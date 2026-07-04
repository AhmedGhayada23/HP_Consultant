import 'package:hb/core/data/models/industry_model.dart';
import 'package:hb/core/domain/repository/industry_repository.dart';

class IndustryUsecase {
  final IndustryRepository repository;

  IndustryUsecase(this.repository);

  Future<List<IndustryModel>> call() => repository.getIndustries();
}
