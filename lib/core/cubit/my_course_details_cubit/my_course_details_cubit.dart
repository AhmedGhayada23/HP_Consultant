import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/my_course_details_cubit/my_course_details_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class MyCourseDetailsCubit extends Cubit<MyCourseDetailsState> {
  MyCourseDetailsCubit() : super(MyCourseDetailsState());

  Future<void> fetchMyCourseDetails(int courseId) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.myCourseDetailsUsecase.call(courseId);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  // تسجيل إكمال درس ثم تحديث تفاصيل الدورة — يرجّع true عند النجاح
  Future<bool> completeLesson(int lessonId, int courseId) async {
    try {
      await UseCases.myCourseDetailsUsecase.completeLesson(lessonId);
      await fetchMyCourseDetails(courseId); // تحديث التفاصيل بعد النجاح
      return true;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      return false;
    }
  }
}
