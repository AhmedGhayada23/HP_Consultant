import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/service_request_cubit/service_request_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  ServiceRequestCubit() : super(ServiceRequestState());

  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController supportingDocController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<PlatformFile> supportingDocs = [];
  void setSupportingDocs(List<PlatformFile> files) {
    supportingDocs = files;
  }

   DateTime? deadlineDate;
  void setDeadline(DateTime date) {
    deadlineDate = date;
    emit(state.copyWith());
  }

  // yyyy-MM-dd للـ API
  String get _formattedDeadline {
    final d = deadlineDate;
    if (d != null) {
      return "${d.year.toString().padLeft(4, '0')}-"
          "${d.month.toString().padLeft(2, '0')}-"
          "${d.day.toString().padLeft(2, '0')}";
    }
    return deadlineController.text.trim();
  }

  // ── أنواع الخدمات (dropdown) ───────────────────────────────────────────────
  Future<void> fetchServiceTypes() async {
    emit(state.copyWith(serviceTypesLoading: true));
    try {
      final types = await UseCases.getServiceTypesUsecase();
      emit(state.copyWith(serviceTypes: types, serviceTypesLoading: false));
    } catch (e) {
      emit(state.copyWith(
        serviceTypesLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void setServiceType(int id) {
    emit(state.copyWith(selectedServiceTypeId: id));
  }

  void toggleAllowReview(bool value) {
    emit(state.copyWith(allowReview: value));
  }



  Future<void> submitServiceRequest(BuildContext context) async {
    if (state.selectedServiceTypeId == null) {
      showCustomSnackBar(context, 'Please select a service type.', SnackBarType.error);
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

    emit(state.copyWith(loading: true, success: false, errorMessage: null));
    try {
      await UseCases.createServiceRequestUsecase(
        serviceId: state.selectedServiceTypeId!,
        preferredDeadline: _formattedDeadline,
        proposedBudget: budgetController.text.trim(),
        description: descriptionController.text.trim(),
        allowAdminReview: state.allowReview,
        documents: supportingDocs,
      );
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false, errorMessage: e.toString()));
      if (context.mounted) {
        showCustomSnackBar(context, e.toString(), SnackBarType.error);
      }
    }
  }

  @override
  Future<void> close() {
    deadlineController.dispose();
    supportingDocController.dispose();
    budgetController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
