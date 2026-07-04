import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/milestone_cubit/milestone_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class MilestoneCubit extends Cubit<MilestoneState> {
  MilestoneCubit() : super(MilestoneState());

  Future<void> getMilestone(int projectId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await UseCases.getMilestoneUsecase.milestone(projectId);

      emit(state.copyWith(milestone: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
