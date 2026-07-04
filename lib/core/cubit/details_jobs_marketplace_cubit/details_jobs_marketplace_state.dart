import 'package:hb/core/data/models/details_jobs_marketplace_model.dart';

class DetailsJobsMarketplaceState {
  final DetailsJobsMarketplaceModel? data;
  final bool loading;
  final String? errorMessage;

  DetailsJobsMarketplaceState({
    this.data,
    this.loading = false,
    this.errorMessage,
  });

  DetailsJobsMarketplaceState copyWith({
    DetailsJobsMarketplaceModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsJobsMarketplaceState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
