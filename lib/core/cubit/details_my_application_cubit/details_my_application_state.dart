import 'package:hb/core/data/models/details_my_application_model.dart';

class DetailsMyApplicationState {
  final DetailsMyApplicationModel? data;
  final bool loading;
  final String? errorMessage;

  DetailsMyApplicationState({this.data, this.loading = false, this.errorMessage});

  DetailsMyApplicationState copyWith({
    DetailsMyApplicationModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsMyApplicationState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
