import 'package:hb/core/data/models/job_project_model.dart';

class JobProjectState {
  final List<JobProjectModel>? data;
  final bool? loading;
  final String? errorMessage;

  JobProjectState({this.data, this.loading, this.errorMessage});

  JobProjectState copyWith({List<JobProjectModel>? data, bool? loading, String? errorMessage}) {
    return JobProjectState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
