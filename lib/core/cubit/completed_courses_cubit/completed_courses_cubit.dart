import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/completed_courses_cubit/completed_courses_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class CompletedCoursesCubit extends Cubit<CompletedCoursesState> {
  CompletedCoursesCubit() : super(CompletedCoursesState());

  Future<void> fetchCompletedCourses() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.completedCoursesUsecase.call();
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
