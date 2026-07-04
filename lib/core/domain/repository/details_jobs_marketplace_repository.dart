import 'package:hb/core/data/datasource/details_jobs_marketplace_data_source.dart';
import 'package:hb/core/data/models/details_jobs_marketplace_model.dart';

abstract class DetailsJobsMarketplaceRepository {
  Future<DetailsJobsMarketplaceModel> getDetailsJobsMarketplace(int id);
}

class DetailsJobsMarketplaceRepositoryImpl
    implements DetailsJobsMarketplaceRepository {
  final DetailsJobsMarketplaceDataSource dataSource;
  DetailsJobsMarketplaceRepositoryImpl(this.dataSource);

  @override
  Future<DetailsJobsMarketplaceModel> getDetailsJobsMarketplace(int id) {
    return dataSource.getDetailsJobsMarketplace(id);
  }
}
