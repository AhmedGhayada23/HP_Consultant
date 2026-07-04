import 'package:hb/core/data/models/my_course_details_model.dart';

class MyCourseDetailsState {
  final MyCourseDetailsModel? data;
  final bool loading;
  final String? errorMessage;

  MyCourseDetailsState({this.data, this.loading = false, this.errorMessage});

  MyCourseDetailsState copyWith({
    MyCourseDetailsModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return MyCourseDetailsState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
