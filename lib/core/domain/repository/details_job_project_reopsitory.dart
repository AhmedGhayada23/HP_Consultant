import 'package:hb/core/data/datasource/details_job_project_data_source.dart';
import 'package:hb/core/data/models/details_job_project_model.dart';

abstract class DetailsJobProjectReopsitory {
  Future<DetailsJobProjectModel> getDetailsJobProject(int jobId);
}

class DetailsJobProjectReopsitoryImpl extends DetailsJobProjectReopsitory {
  final DetailsJobProjectDataSource dataSource;
  DetailsJobProjectReopsitoryImpl(this.dataSource);

  @override
  Future<DetailsJobProjectModel> getDetailsJobProject(int jobId) {
    return dataSource.getDetailsJobProject(jobId);
  }
}
