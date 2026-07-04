import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/course_detail_cubit/course_detail_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class CourseDetailCubit extends Cubit<CourseDetailState> {
  CourseDetailCubit() : super(CourseDetailState());

  Future<void> fetchCourseDetail(int courseId) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final courseDetails = await UseCases.getCourseDetailUseCase(courseId);
      emit(state.copyWith(courseDetails: courseDetails, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
