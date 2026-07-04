import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/job_apply_cubit/job_apply_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

class JobApplyCubit extends Cubit<JobApplyState> {
  JobApplyCubit() : super(JobApplyState());

  final TextEditingController rateController = TextEditingController();
  final TextEditingController estimatedDurationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController supportingDocController = TextEditingController();
  final TextEditingController coverLetterController = TextEditingController();

  DateTime? startDate;
  String? _supportingDocPath;

  void toggleConfirmInfo(bool value) => emit(state.copyWith(confirmInfo: value));
  void toggleAllowReview(bool value) => emit(state.copyWith(allowReview: value));

  void setStartDate(DateTime date) {
    startDate = date;
    emit(state.copyWith());
  }

  void setSupportingDocPath(String? path) {
    _supportingDocPath = path;
  }

  void clearFields() {
    rateController.clear();
    estimatedDurationController.clear();
    startDateController.clear();
    supportingDocController.clear();
    coverLetterController.clear();
    startDate = null;
    _supportingDocPath = null;
    emit(JobApplyState());
  }

  Future<void> newJopApply(BuildContext context, int jobId) async {
    if (!state.confirmInfo) {
      showCustomSnackBar(
        context,
        'Please confirm that all information is accurate.',
        SnackBarType.error,
      );
      return;
    }
    if (!state.allowReview) {
      showCustomSnackBar(
        context,
        'Please allow HB Admin to review your proposal.',
        SnackBarType.error,
      );
      return;
    }

    emit(state.copyWith(loading: true, errorMessage: null, success: false));
    try {
      final success = await UseCases.getJobApplyUsecase(
        context: context,
        jobId: jobId,
        proposedRate: rateController.text.trim(),
        durationWeeks: estimatedDurationController.text.trim(),
        availabilityStartDate: startDateController.text.trim(),
        coverLetter: coverLetterController.text.trim(),
        adminPreviewRequested: state.allowReview,
        informationAccuracyConfirmed: state.confirmInfo,
        supportingDocPath: _supportingDocPath,
      );
      emit(state.copyWith(loading: false, success: success));
      if (success) clearFields();
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
      if (context.mounted) {
        showCustomSnackBar(context, e.toString(), SnackBarType.error);
      }
    }
  }

  @override
  Future<void> close() {
    rateController.dispose();
    estimatedDurationController.dispose();
    startDateController.dispose();
    supportingDocController.dispose();
    coverLetterController.dispose();
    return super.close();
  }
}
