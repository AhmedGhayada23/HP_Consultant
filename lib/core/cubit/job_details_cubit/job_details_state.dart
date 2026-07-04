import 'package:hb/core/data/models/job_details_modle.dart';

class JobDetailsState {
  final JobDetailsModle? jobDetails;
  final bool isLoading;
  final String errorMessage;

  JobDetailsState({
    this.jobDetails,
    this.isLoading = false,
    this.errorMessage = '',
  });

  JobDetailsState copyWith({
    JobDetailsModle? jobDetails,
    bool? isLoading,
    String? errorMessage,
  }) {
    return JobDetailsState(
     jobDetails: jobDetails ?? this.jobDetails,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
