import 'package:hb/core/data/datasource/details_job_talent_data_source.dart';
import 'package:hb/core/data/models/details_job_talent_model.dart';

abstract class DetailsJobTalentRepository {
  Future<DetailsJobTalentModel> getDetailsJobTalent();
}

class DetailsJobTalentRepositoryImpl extends DetailsJobTalentRepository {
  final DetailsJobTalentDataSource dataSource;
  DetailsJobTalentRepositoryImpl(this.dataSource);

  @override
  Future<DetailsJobTalentModel> getDetailsJobTalent() {
    return dataSource.getDetailsJobTalent();
  }
}
