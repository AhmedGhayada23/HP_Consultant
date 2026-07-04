import 'package:hb/core/data/models/details_job_talent_model.dart';

class DetailsJobTalentState {
  final DetailsJobTalentModel? data;
  final bool? loading;
  final String? errorMessage;

  DetailsJobTalentState({this.data, this.loading = false, this.errorMessage});

  DetailsJobTalentState copyWith({
    DetailsJobTalentModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsJobTalentState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
