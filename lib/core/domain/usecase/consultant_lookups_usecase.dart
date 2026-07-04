import 'package:hb/core/data/models/consultant_lookups_model.dart';
import 'package:hb/core/domain/repository/consultant_lookups_repository.dart';

class ConsultantLookupsUsecase {
  final ConsultantLookupsRepository repository;
  ConsultantLookupsUsecase(this.repository);

  Future<ConsultantLookupsModel> call() => repository.getConsultantLookups();
}
