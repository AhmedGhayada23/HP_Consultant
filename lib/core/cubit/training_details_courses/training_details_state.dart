import 'package:hb/core/data/models/course_details_model.dart';

class TrainingDetailsState {
  final CourseDetailsModel? courseDetails;
  final bool isLoading;
  final String? errorMessage;

  TrainingDetailsState({this.courseDetails, this.isLoading = false, this.errorMessage});

  TrainingDetailsState copyWith({
    CourseDetailsModel? courseDetails,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TrainingDetailsState(
      courseDetails: courseDetails ?? this.courseDetails,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
