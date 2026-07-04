import 'package:hb/core/data/datasource/details_ideas_box_data_source.dart';
import 'package:hb/core/data/models/details_ideas_box_model.dart';

abstract class DetailsIdeasBoxRepository {
  Future<DetailsIdeasBoxModel> getDetailsIdeasBox(int id);
}

class DetailsIdeasBoxRepositoryImpl extends DetailsIdeasBoxRepository {
  final DetailsIdeasBoxDataSource dataSource;
  DetailsIdeasBoxRepositoryImpl(this.dataSource);

  @override
  Future<DetailsIdeasBoxModel> getDetailsIdeasBox(int id) {
    return dataSource.getDetailsIdeasBox(id);
  }
}
