import 'package:hb/core/data/models/consultant_profile_details_model.dart';

class ConsultantProfileState {
  final ConsultantProfileDetailsModel? data;
  final bool loading;
  final String? errorMessage;

  ConsultantProfileState({this.data, this.loading = false, this.errorMessage});

  ConsultantProfileState copyWith({
    ConsultantProfileDetailsModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return ConsultantProfileState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
