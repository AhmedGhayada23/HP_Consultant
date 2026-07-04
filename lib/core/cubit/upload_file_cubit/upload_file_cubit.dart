import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:hb/core/cubit/upload_file_cubit/upload_file_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class UploadFileCubit extends Cubit<UploadFileState> {
  UploadFileCubit() : super(UploadFileState());

  // Controller
  final fileController = TextEditingController();

  // picked file
  PlatformFile? pickedFile;

  // deliverables selections
  int? selectedMilestoneId;
  bool markCompleted = false;

  void setFile(PlatformFile file) {
    pickedFile = file;
    fileController.text = file.name; // للتحديث في TextField
    emit(state.copyWith());
  }

  void setMilestone(int? milestoneId) {
    selectedMilestoneId = milestoneId;
    emit(state.copyWith());
  }

  void setMarkCompleted(bool value) {
    markCompleted = value;
    emit(state.copyWith());
  }

  void reset() {
    pickedFile = null;
    fileController.clear();
    selectedMilestoneId = null;
    markCompleted = false;
    emit(UploadFileState());
  }

  Future<void> uploadFile({required BuildContext context, required int projectId}) async {
    if (pickedFile == null || pickedFile!.path == null) return;

    emit(state.copyWith(isLoading: true, success: null, errorMessage: null));

    try {
      await UseCases.uploadProjectFileUseCase.call(
        context: context,
        projectId: projectId,
        file: File(pickedFile!.path!),
        fileType: 'deliverable',
      );

      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, success: false, errorMessage: e.toString()));
    }
  }

  Future<void> uploadDeliverables({required int projectId}) async {
    if (pickedFile == null || pickedFile!.path == null) return;
    if (selectedMilestoneId == null) return;

    emit(state.copyWith(isLoading: true, success: null, errorMessage: null));

    try {
      await UseCases.uploadProjectFileUseCase.uploadDeliverables(
        projectId: projectId,
        milestoneId: selectedMilestoneId!,
        markCompleted: markCompleted,
        file: File(pickedFile!.path!),
      );

      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, success: false, errorMessage: e.toString()));
    }
  }
}
