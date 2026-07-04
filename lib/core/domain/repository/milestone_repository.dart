import 'package:hb/core/data/datasource/milestone_remote_data_source.dart';
import 'package:hb/core/data/models/milestone_model.dart';

abstract class MilestoneRepository {
  Future<List<MilestoneModel>> milestone(int projectId);
}

class MilestoneRepositoryImpl extends MilestoneRepository {
  final MilestoneRemoteDataSource _dataSource;
  MilestoneRepositoryImpl(this._dataSource);
  @override
  Future<List<MilestoneModel>> milestone(int projectId) {
    return _dataSource.milestone(projectId);
  }
}
