import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/consultant_meeting_request_cubit/consultant_meeting_request_cubit.dart';
import 'package:hb/core/cubit/consultant_request_cubit/consultant_request_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ConsultantRequestCubit extends Cubit<ConsultantRequestState> {
  ConsultantRequestCubit() : super(ConsultantRequestState());

  final TextEditingController titleRequestController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController budgetMinController = TextEditingController();
  final TextEditingController budgetMaxController = TextEditingController();
  final TextEditingController uploadDecController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? startDate;

  // ✅ Dropdown values
  String? selectedCategory;
  String? selectedConsultantType;
  String? selectedUrgency;
  String? selectedEstimatedDuration;

  // ✅ مسار الملف المختار
  String? supportingDocumentPath;

  void setStartDate(DateTime date) {
    startDate = date;
    emit(state.copyWith());
  }

  void setCategory(String value) {
    selectedCategory = value;
    emit(state.copyWith());
  }

  void setConsultantType(String value) {
    selectedConsultantType = value;
    emit(state.copyWith());
  }

  void setUrgency(String value) {
    selectedUrgency = value;
    emit(state.copyWith());
  }

  void setEstimatedDuration(String value) {
    selectedEstimatedDuration = value;
    emit(state.copyWith());
  }

  void setDocument(String filePath) {
    supportingDocumentPath = filePath;
    emit(state.copyWith());
  }

  // تفريغ جميع بيانات النموذج بعد النجاح
  void clearAll() {
    titleRequestController.clear();
    startDateController.clear();
    budgetMinController.clear();
    budgetMaxController.clear();
    uploadDecController.clear();
    descriptionController.clear();
    startDate = null;
    selectedCategory = null;
    selectedConsultantType = null;
    selectedUrgency = null;
    selectedEstimatedDuration = null;
    supportingDocumentPath = null;
    emit(ConsultantRequestState());
  }

  void newConsultantRequest(BuildContext context) async {
    // حالة جديدة لتصفير success/errorMessage السابقين
    emit(ConsultantRequestState(loading: true, success: false));

    try {
      final Map<String, dynamic> meetingData = {
        'title': titleRequestController.text,
        'category': selectedCategory ?? '',
        'consultant_type': selectedConsultantType ?? '',
        'preferred_start_date': startDateController.text,
        'urgency': selectedUrgency ?? '',
        'estimated_duration': selectedEstimatedDuration ?? '',
        'budget_min': budgetMinController.text,
        'budget_max': budgetMaxController.text,
        'description': descriptionController.text,
        'supporting_document': supportingDocumentPath, // null لو ما اختار ملف
      };

      await UseCases.getConsultantMeetingRequestUsecase.addMeetingRequests(
        context: context,
        meetingData: meetingData,
      );

      emit(ConsultantRequestState(loading: false, success: true));

    } catch (e) {
      emit(ConsultantRequestState(loading: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    titleRequestController.dispose();
    startDateController.dispose();
    budgetMinController.dispose();
    budgetMaxController.dispose();
    uploadDecController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
