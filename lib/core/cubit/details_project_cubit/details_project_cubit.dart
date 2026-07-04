import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_project_cubit/details_project_state.dart';
import 'package:hb/core/data/models/details_project_model.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsProjectCubit extends Cubit<DetailsProjectState> {
  DetailsProjectCubit() : super(DetailsProjectState());

  Future<void> fetchDetailsProject(int id) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = await UseCases.getDetailsProjectUsecase(id);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  void updateMilestoneAssignedTo({required int milestoneId, required String consultantName}) {
    final currentData = state.data;
    log('currentData: $currentData'); // ✅ تأكد مش null
    log('milestoneId: $milestoneId'); // ✅ تأكد الـ ID صح
    log('consultantName: $consultantName'); // ✅ تأكد الاسم وصل

    if (currentData == null) return;

    final updatedMilestones = currentData.projectMilestones.map((milestone) {
      if (milestone.id == milestoneId) {
        return milestone.copyWith(assignedTo: consultantName);
      }
      return milestone;
    }).toList();

    emit(
      state.copyWith(
        data: DetailsProjectModel(
          project: currentData.project,
          assignedConsultants: currentData.assignedConsultants,
          projectMilestones: updatedMilestones,
          projectFiles: currentData.projectFiles,
        ),
      ),
    );
  }

  Future<void> closeProject(BuildContext context, int id) async {
    await UseCases.getDetailsProjectUsecase.closeProject(context, id);
  }
}
