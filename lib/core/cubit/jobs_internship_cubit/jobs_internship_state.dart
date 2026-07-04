import 'package:hb/core/data/models/jobs_internship_model.dart';

class JobsInternshipState {
  final List<JobsInternshipModel>? data;
  final bool? loading;
  final String? errorMessage;
  final Map<String, String> jobTypes; // value -> label (متراكمة)

  JobsInternshipState({
    this.data,
    this.loading,
    this.errorMessage,
    this.jobTypes = const {},
  });

  JobsInternshipState copyWith({
    List<JobsInternshipModel>? data,
    bool? loading,
    String? errorMessage,
    Map<String, String>? jobTypes,
  }) {
    return JobsInternshipState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      jobTypes: jobTypes ?? this.jobTypes,
    );
  }
}
