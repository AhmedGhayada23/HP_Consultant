import 'package:hb/core/data/models/job_application_model.dart';

class JobApplicationState {
  final List<JobApplicationModel>? data;
  final bool? loading;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int total;

  JobApplicationState({
    this.data,
    this.loading,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
  });

  JobApplicationState copyWith({
    List<JobApplicationModel>? data,
    bool? loading,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    int? total,
  }) {
    return JobApplicationState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
    );
  }
}
