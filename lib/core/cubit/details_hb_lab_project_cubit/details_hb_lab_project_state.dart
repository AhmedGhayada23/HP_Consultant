import 'package:hb/core/data/models/details_hb_lab_project_model.dart';

class DetailsHbLabProjectState {
  final DetailsHbLabProjectModel? data;
  final bool loading;
  final String? errorMessage;

  DetailsHbLabProjectState({
    this.data,
    this.loading = false,
    this.errorMessage,
  });

  DetailsHbLabProjectState copyWith({
    DetailsHbLabProjectModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsHbLabProjectState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
