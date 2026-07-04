import 'package:hb/core/data/models/milestone_model.dart';
import 'package:hb/core/domain/repository/milestone_repository.dart';

class MilestoneUsecase {
  final MilestoneRepository _repository;
  MilestoneUsecase(this._repository);

    Future<List<MilestoneModel>> milestone(int projectId) async{
    return await _repository.milestone(projectId);
  }
}
