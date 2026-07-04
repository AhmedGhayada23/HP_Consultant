import 'package:hb/core/data/models/details_consultant_project_model.dart';

class DetailsConsultantProjectState {
  final DetailsConsultantProjectModel? data;
  final bool? loading;
  final String? errorMessage;

  DetailsConsultantProjectState({this.data, this.loading, this.errorMessage});

  DetailsConsultantProjectState copyWith({
    DetailsConsultantProjectModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsConsultantProjectState(
      data:  data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
