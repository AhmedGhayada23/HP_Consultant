import 'package:hb/core/data/models/details_ideas_box_model.dart';

class DetailsIdeasBoxState {
  final DetailsIdeasBoxModel? data;
  final bool loading;
  final String? errorMessage;

  DetailsIdeasBoxState({
    this.data,
    this.loading = false,
    this.errorMessage,
  });

  DetailsIdeasBoxState copyWith({
    DetailsIdeasBoxModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsIdeasBoxState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
