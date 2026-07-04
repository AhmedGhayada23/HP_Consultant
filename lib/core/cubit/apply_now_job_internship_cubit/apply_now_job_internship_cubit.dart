import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/apply_now_job_internship_cubit/apply_now_job_internship_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ApplyNowJobInternshipCubit extends Cubit<ApplyNowJobInternshipState> {
  ApplyNowJobInternshipCubit() : super(ApplyNowJobInternshipState());

  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController startDateTextEditingController = TextEditingController();
  final TextEditingController supporingTextEditingController = TextEditingController();
  final TextEditingController coverTextEditingController = TextEditingController();

  DateTime? deadlineDate;
  void setDeadline(DateTime date) {
    deadlineDate = date;
    emit(state.copyWith());
  }

  // الملف المختار (CV)
  PlatformFile? cvFile; // Supporting Documents
  List<int> completedCourseIds = [];

  void setCvFile(PlatformFile file) {
    cvFile = file;
    emit(state.copyWith());
  }

  void setCompletedCourseIds(List<int> ids) {
    completedCourseIds = ids;
    emit(state.copyWith());
  }

  void toggleConfirmInfo(bool value) {
    emit(state.copyWith(confirmInfo: value));
  }

  void toggleAllowReview(bool value) {
    emit(state.copyWith(allowReview: value));
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String get _availabilityDate {
    final d = deadlineDate;
    if (d == null) return '';
    return '${d.year}-${_two(d.month)}-${_two(d.day)}';
  }

  Future<void> applyNowJobInternship(BuildContext context, {required int jobId}) async {
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

    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));

    try {
      await UseCases.applyJobUsecase.call(
        jobId: jobId,
        applicantName: nameTextEditingController.text.trim(),
        applicantEmail: emailTextEditingController.text.trim(),
        availabilityStartDate: _availabilityDate,
        informationAccuracyConfirmed: state.confirmInfo,
        adminPreviewRequested: state.allowReview,
        coverLetter: coverTextEditingController.text.trim(),
        cvPath: cvFile?.path,
        completedCourseIds: completedCourseIds,
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isSuccess: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    startDateTextEditingController.dispose();
    supporingTextEditingController.dispose();
    coverTextEditingController.dispose();
    return super.close();
  }
}
