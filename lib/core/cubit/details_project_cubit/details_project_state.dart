import 'package:hb/core/data/models/details_project_model.dart';

class DetailsProjectState {
  final DetailsProjectModel? data;
  final bool? loading;
  final String? errorMessage;

  DetailsProjectState({this.data, this.loading, this.errorMessage});

  DetailsProjectState copyWith({DetailsProjectModel? data, bool? loading, String? errorMessage}) {
    return DetailsProjectState(
      data: data ?? this.data,
      loading:  loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
