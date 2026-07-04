import 'package:hb/core/data/models/purchased_course_model.dart';

class PurchasedCourseSate {
  final List<PurchasedCourseModle>? purchasedCourseModle;
  final bool loading;
  final String? errorMessage;

  PurchasedCourseSate({this.purchasedCourseModle, this.loading = false, this.errorMessage});

  PurchasedCourseSate copyWith({
   List<PurchasedCourseModle>? purchasedCourseModle,
   bool? loading,
   String? errorMessage,
  }){
    return PurchasedCourseSate(
       purchasedCourseModle: purchasedCourseModle ?? this.purchasedCourseModle,
       loading: loading ?? this.loading,
       errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
