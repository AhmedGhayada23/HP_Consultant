import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/request_consultant_cubit/request_consultant_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

class RequestConsultantCubit extends Cubit<RequestConsultantState> {
  RequestConsultantCubit() : super(RequestConsultantState());

  final TextEditingController tittleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController supportingDocController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? deadlineDate;
  String? pricingType; // fixed | hourly
  String? priority; // low | medium | high
  List<PlatformFile> supportingDocs = [];

  void setDeadline(DateTime date) {
    deadlineDate = date;
    emit(state.copyWith());
  }

  void setPricingType(String value) {
    pricingType = value;
  }

  void setPriority(String value) {
    priority = value;
  }

  void setSupportingDocs(List<PlatformFile> files) {
    supportingDocs = files;
  }

  void toggleAllowReview(bool value) {
    emit(state.copyWith(allowReview: value));
  }

  // ── أنواع الخدمات (dropdown) ───────────────────────────────────────────────
  Future<void> fetchServiceTypes() async {
    emit(state.copyWith(serviceTypesLoading: true));
    try {
      final types = await UseCases.getServiceTypesUsecase();
      emit(state.copyWith(serviceTypes: types, serviceTypesLoading: false));
    } catch (e) {
      emit(
        state.copyWith(serviceTypesLoading: false, errorMessage: e.toString()),
      );
    }
  }

  void setServiceType(int id) {
    emit(state.copyWith(selectedServiceTypeId: id));
  }

  // تفريغ جميع بيانات النموذج بعد النجاح
  void clearFields() {
    tittleController.clear();
    deadlineController.clear();
    budgetController.clear();
    supportingDocController.clear();
    descriptionController.clear();
    deadlineDate = null;
    pricingType = null;
    priority = null;
    supportingDocs = [];
    // حالة جديدة مع الإبقاء على قائمة أنواع الخدمات المجلوبة
    emit(RequestConsultantState(serviceTypes: state.serviceTypes));
  }

  String get _formattedDeadline {
    final d = deadlineDate;
    if (d != null) {
      return "${d.year.toString().padLeft(4, '0')}-"
          "${d.month.toString().padLeft(2, '0')}-"
          "${d.day.toString().padLeft(2, '0')}";
    }
    return deadlineController.text.trim();
  }

  Future<void> requestConsultant(
    BuildContext context, {
    required int consultantId,
  }) async {
    if (state.selectedServiceTypeId == null) {
      showCustomSnackBar(
        context,
        'Please select a service type.',
        SnackBarType.error,
      );
      return;
    }
    if (pricingType == null || pricingType!.isEmpty) {
      showCustomSnackBar(
        context,
        'Please select pricing type.',
        SnackBarType.error,
      );
      return;
    }
    if (priority == null || priority!.isEmpty) {
      showCustomSnackBar(
        context,
        'Please select priority.',
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

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isRequestSuccessful: false,
      ),
    );
    try {
      await UseCases.createConsultantRequestUsecase(
        serviceId: state.selectedServiceTypeId!,
        consultantId: consultantId,
        projectTitle: tittleController.text.trim(),
        preferredDeadline: _formattedDeadline,
        pricingType: pricingType!,
        proposedBudget: budgetController.text.trim(),
        priority: priority!,
        description: descriptionController.text.trim(),
        allowAdminReview: state.allowReview,
        documents: supportingDocs,
      );
      emit(state.copyWith(isLoading: false, isRequestSuccessful: true));
      clearFields(); // تفريغ البيانات بعد النجاح
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      if (context.mounted) {
        showCustomSnackBar(context, e.toString(), SnackBarType.error);
      }
    }
  }

  @override
  Future<void> close() {
    tittleController.dispose();
    deadlineController.dispose();
    budgetController.dispose();
    supportingDocController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
