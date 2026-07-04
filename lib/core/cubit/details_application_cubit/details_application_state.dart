import 'package:hb/core/data/models/details_application_model.dart';

class DetailsApplicationState {
  final DetailsApplicationModel? data;
  final bool? loading;
  final String? errorMessage;

  DetailsApplicationState({this.data, this.loading, this.errorMessage});

  DetailsApplicationState copyWith({
    DetailsApplicationModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsApplicationState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
