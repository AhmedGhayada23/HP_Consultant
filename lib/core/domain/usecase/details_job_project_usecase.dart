import 'package:hb/core/data/models/details_job_project_model.dart';
import 'package:hb/core/domain/repository/details_job_project_reopsitory.dart';

class DetailsJobProjectUsecase {
  final DetailsJobProjectReopsitory reopsitory;
  DetailsJobProjectUsecase(this.reopsitory);

  Future<DetailsJobProjectModel> call(int jobId) async {
    return await reopsitory.getDetailsJobProject(jobId);
  }
}
