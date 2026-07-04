import 'package:hb/core/data/models/details_job_project_model.dart';

class DetailsJobProjectState {
  final DetailsJobProjectModel? data;
  final bool? loading;
  final String? errorMessage;

  DetailsJobProjectState({this.data, this.loading, this.errorMessage});

  DetailsJobProjectState copyWith({
    DetailsJobProjectModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsJobProjectState(
      data:  data ?? this.data,
      loading:  loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
