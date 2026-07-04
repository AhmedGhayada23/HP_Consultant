// lib/featuer/my_coureses/presentation/cubit/courses_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/my_courses_cubit/my_courses_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {
  MyCoursesCubit() : super(MyCoursesState());

  Future<void> fetchMyCourses() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getMyCouresesUsecase();
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
