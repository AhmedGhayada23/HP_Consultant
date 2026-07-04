import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/active_project_cubit/active_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ActiveProjectCubit extends Cubit<ActiveProjectState> {
  ActiveProjectCubit() : super(ActiveProjectState());

  final TextEditingController deadlineFromTextEditingController = TextEditingController();
  final TextEditingController deadlineToTextEditingController = TextEditingController();


  void fetchActiveProject({
    String? status,
    String? deadlineFrom,
    String? deadlineTo,
    String? name,
    String? consultant,
  }) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      // Simulate fetching chat data
      await Future.delayed(Duration(seconds: 2));
      // Assume we fetched some chat data
      final data = await UseCases.getActiveProjectUsecase(
        status: status,
        deadlineFrom: deadlineFrom,
        deadlineTo: deadlineTo,
        name: name,
        consultant: consultant,
      ); // Replace with actual data fetching logic
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
