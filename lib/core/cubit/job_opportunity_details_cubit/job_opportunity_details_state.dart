import 'package:hb/core/data/models/job_opportunity_details_model.dart';

class JobOpportunityDetailsState {
  final JobOpportunityDetailsModel? data;
  final bool loading;
  final String? errorMessage;

  JobOpportunityDetailsState({this.data, this.loading = false, this.errorMessage});

  JobOpportunityDetailsState copyWith({
    JobOpportunityDetailsModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return JobOpportunityDetailsState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
