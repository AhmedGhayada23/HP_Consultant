import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/assign_consultant_cubit/assign_consultant_state.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_cubit.dart';
import 'package:hb/core/data/models/assign_consultant_model.dart';
import 'package:hb/core/service_locator/usecases.dart';

class AssignConsultantCubit extends Cubit<AssignConsultantState> {
  AssignConsultantCubit() : super(AssignConsultantState());

  Future<void> assignConsultant(
    int projectId,
    AssignConsultantModel model,
    BuildContext context,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await UseCases.getAssignConsultantUsecase.assignConsultant(context, projectId, model);
      emit(state.copyWith(isLoading: false, success: true));

      if (context.mounted) {
        Navigator.pop(context);
        // ✅ تحديث (refresh) تفاصيل المشروع بعد النجاح
        context.read<DetailsProjectCubit>().fetchDetailsProject(projectId);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
