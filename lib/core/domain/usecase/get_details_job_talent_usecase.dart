import 'package:hb/core/data/models/details_job_talent_model.dart';
import 'package:hb/core/domain/repository/details_job_talent_repository.dart';

class  GetDetailsJobTalentUsecase{
  final DetailsJobTalentRepository repository;

  GetDetailsJobTalentUsecase(this.repository);

  Future<DetailsJobTalentModel> call() async {
    return await repository.getDetailsJobTalent();
  }
}
