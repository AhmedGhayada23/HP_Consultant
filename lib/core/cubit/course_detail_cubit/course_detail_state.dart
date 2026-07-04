import 'package:hb/core/data/models/course_detail_model.dart';

class CourseDetailState {
  final CourseDetailModel? courseDetails;
  final bool? loading;
  final String? errorMessage;

CourseDetailState({
  this.courseDetails,
  this.loading,
  this.errorMessage,
});



CourseDetailState copyWith({
  CourseDetailModel? courseDetails,
  bool? loading,
  String? errorMessage,
}){
 return CourseDetailState(
    courseDetails: courseDetails  ?? this.courseDetails,
    loading:  loading ?? this.loading,
    errorMessage:  errorMessage ?? this.errorMessage,
  );
}

}
