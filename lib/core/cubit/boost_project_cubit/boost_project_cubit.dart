import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/boost_project_cubit/boost_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class BoostProjectCubit extends Cubit<BoostProjectState> {
  BoostProjectCubit() : super(BoostProjectState());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController goalsController = TextEditingController();
  final TextEditingController supportingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<String> selectedCategoryTags = [];
  DateTime? deadlineDate;
  String? _attachmentPath;

  void setDeadline(DateTime date) {
    deadlineDate = date;
    emit(state.copyWith());
  }

  void setAttachmentPath(String? path) {
    _attachmentPath = path;
  }

  Future<void> boostProject(BuildContext context) async {
    emit(state.copyWith(loading: true, success: false));
    try {
      final success = await UseCases.getBoostProjectUsecase(
        context: context,
        title: titleController.text.trim(),
        categoryTags: selectedCategoryTags,
        budget: budgetController.text.trim(),
        deadline: deadlineController.text.trim(),
        description: descriptionController.text.trim(),
        goalsDeliverables: goalsController.text.trim(),
        attachmentPath: _attachmentPath,
      );
      emit(state.copyWith(loading: false, success: success));
      if (success) clearFields();
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  void clearFields() {
    titleController.clear();
    budgetController.clear();
    deadlineController.clear();
    goalsController.clear();
    supportingController.clear();
    descriptionController.clear();
    selectedCategoryTags = [];
    deadlineDate = null;
    _attachmentPath = null;
    emit(BoostProjectState());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    budgetController.dispose();
    deadlineController.dispose();
    goalsController.dispose();
    supportingController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
