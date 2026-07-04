
import 'package:hb/core/data/models/consultant_project_model.dart';

class ConsultantProjectState {
  final List<ConsultantProjectModel>? consultantProjectData;
  final bool loading;
  final String? errorMessage;

  ConsultantProjectState({this.consultantProjectData, this.loading = false, this.errorMessage});

  ConsultantProjectState copyWith({
    List<ConsultantProjectModel>? consultantProjectData,
    bool? loading,
    String? errorMessage,
  }) {
    return ConsultantProjectState(
      consultantProjectData: consultantProjectData ?? this.consultantProjectData,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
