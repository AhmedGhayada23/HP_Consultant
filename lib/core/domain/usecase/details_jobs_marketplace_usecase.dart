import 'package:hb/core/data/models/details_jobs_marketplace_model.dart';
import 'package:hb/core/domain/repository/details_jobs_marketplace_repository.dart';

class DetailsJobsMarketplaceUsecase {
  final DetailsJobsMarketplaceRepository repository;
  DetailsJobsMarketplaceUsecase(this.repository);

  Future<DetailsJobsMarketplaceModel> call(int id) {
    return repository.getDetailsJobsMarketplace(id);
  }
}
