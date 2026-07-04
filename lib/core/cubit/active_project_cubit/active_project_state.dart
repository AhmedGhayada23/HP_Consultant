import 'package:hb/core/data/models/active_project_model.dart';

class ActiveProjectState {
  final List<ActiveProjectModel>? data;
  final bool? loading;
  final String? errorMessage;

  ActiveProjectState({this.data, this.loading, this.errorMessage});

  ActiveProjectState copyWith({
    List<ActiveProjectModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return ActiveProjectState(
      data:  data ?? this.data,
      loading:  loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
