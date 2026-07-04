import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/new_idea_cubit/new_idea_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class NewIdeaCubit extends Cubit<NewIdeaState> {
  // consultant: يستخدم endpoint قسم الاستشاري (/api/consultant/...)
  final bool consultant;
  NewIdeaCubit({this.consultant = false}) : super(NewIdeaState());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController supportingDocController = TextEditingController();
  final TextEditingController updatedDescriptionController =
      TextEditingController();

  List<String> selectedTags = [];
  String? confidentialityLevel;
  String? _attachmentPath;

  void setAttachmentPath(String? path) {
    _attachmentPath = path;
  }

  Future<void> newIdea(BuildContext context) async {
    emit(state.copyWith(loading: true, success: false));
    try {
      final usecase = consultant
          ? UseCases.getSubmitIdeaConsultantUsecase
          : UseCases.getSubmitIdeaUsecase;
      final success = await usecase(
        context: context,
        title: titleController.text.trim(),
        description: updatedDescriptionController.text.trim(),
        confidentialityLevel: confidentialityLevel ?? '',
        tags: selectedTags,
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
    supportingDocController.clear();
    updatedDescriptionController.clear();
    selectedTags = [];
    confidentialityLevel = null;
    _attachmentPath = null;
    emit(NewIdeaState());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    supportingDocController.dispose();
    updatedDescriptionController.dispose();
    return super.close();
  }
}
