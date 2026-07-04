import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/training_details_courses/training_details_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class TrainingDetailsCoursesCubit extends Cubit<TrainingDetailsState> {
  TrainingDetailsCoursesCubit() : super(TrainingDetailsState());

  Future<void> getCourseDetails(int courseId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await UseCases.getTrainingCoursesUsecase.getCourseDetails(courseId);

      emit(state.copyWith(courseDetails: data,isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
