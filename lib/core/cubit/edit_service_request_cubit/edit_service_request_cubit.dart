import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/edit_service_request_cubit/edit_service_request_state.dart';
import 'package:hb/core/data/models/service_request_item_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

class EditServiceRequestCubit extends Cubit<EditServiceRequestState> {
  EditServiceRequestCubit() : super(EditServiceRequestState());

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  DateTime? deadlineDate;
  List<PlatformFile> newFiles = [];
  final List<int> removedFileIds = []; // ملفات موجودة محذوفة محلياً

  // حذف محلي لملف موجود (يُرسل عند الحفظ)
  void removeExistingFile(int fileId) {
    if (!removedFileIds.contains(fileId)) {
      removedFileIds.add(fileId);
      emit(state.copyWith());
    }
  }

  static const _months = {
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
    'jul': 7, 'aug': 8, 'sep': 9, 'sept': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  };

  // تعبئة الحقول من الطلب الحالي
  void prefill(ServiceRequestItemModel req) {
    descriptionController.text = req.description;
    budgetController.text = req.proposedBudget.replaceAll(RegExp(r'[^0-9.]'), '');
    deadlineController.text = req.preferredDeadline;
    deadlineDate = _parseDisplayDate(req.preferredDeadline);
  }

  void setDeadline(DateTime date) {
    deadlineDate = date;
    emit(state.copyWith());
  }

  void setFiles(List<PlatformFile> files) {
    newFiles = files;
  }

  DateTime? _parseDisplayDate(String s) {
    final parts = s.trim().split(RegExp(r'\s+'));
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final mon = _months[parts[1].toLowerCase()];
    final year = int.tryParse(parts[2]);
    if (day == null || mon == null || year == null) return null;
    return DateTime(year, mon, day);
  }

  String? get _formattedDeadline {
    final d = deadlineDate;
    if (d == null) return null;
    return "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";
  }

  Future<void> updateRequest(BuildContext context, int id) async {
    emit(state.copyWith(loading: true, success: false, errorMessage: null));
    try {
      await UseCases.updateServiceRequestUsecase(
        id: id,
        description: descriptionController.text.trim(),
        proposedBudget: budgetController.text.trim(),
        preferredDeadline: _formattedDeadline,
        deletedFileIds: removedFileIds,
      );
      if (newFiles.isNotEmpty) {
        await UseCases.uploadServiceRequestFilesUsecase(id: id, files: newFiles);
      }
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
      if (context.mounted) {
        showCustomSnackBar(context, e.toString(), SnackBarType.error);
      }
    }
  }

  @override
  Future<void> close() {
    descriptionController.dispose();
    budgetController.dispose();
    deadlineController.dispose();
    return super.close();
  }
}
