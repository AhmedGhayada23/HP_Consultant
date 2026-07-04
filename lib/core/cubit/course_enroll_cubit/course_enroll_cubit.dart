import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/course_enroll_cubit/course_enroll_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class CourseEnrollCubit extends Cubit<CourseEnrollState> {
  CourseEnrollCubit() : super(CourseEnrollState());

  Future<void> enroll(int courseId) async {
    emit(CourseEnrollState(loadingCourseId: courseId));
    try {
      final result = await UseCases.courseEnrollUsecase.call(courseId);
      emit(CourseEnrollState(result: result));
    } catch (e) {
      emit(CourseEnrollState(errorMessage: e.toString()));
    }
  }

  // لإعادة تعيين الحالة بعد استهلاك النتيجة (فتح الـ WebView)
  void reset() => emit(CourseEnrollState());
}
