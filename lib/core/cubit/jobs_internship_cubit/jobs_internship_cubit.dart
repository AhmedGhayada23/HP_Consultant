import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/jobs_internship_cubit/jobs_internship_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class JobsInternshipCubit extends Cubit<JobsInternshipState> {
  JobsInternshipCubit() : super(JobsInternshipState());

  String? _search;
  int? _categoryId;
  String? _jobType;
  String? _minBudget;
  String? _maxBudget;
  String? _deadlineFrom;
  String? _deadlineTo;

  // أنواع الوظائف المتراكمة (value -> label)
  final Map<String, String> _jobTypes = {};

  void _mergeJobTypes(List data) {
    for (final j in data) {
      final value = j.jobType;
      final label = j.jobTypeLabel;
      if (value != null && value.isNotEmpty) {
        _jobTypes[value] = (label != null && label.isNotEmpty) ? label : value;
      }
    }
  }

  Future<void> fetchJobsInternship({
    String? search,
    int? categoryId,
    String? jobType,
    String? minBudget,
    String? maxBudget,
    String? deadlineFrom,
    String? deadlineTo,
  }) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getJobsInternshipUsecase(
        search: search,
        categoryId: categoryId,
        jobType: jobType,
        minBudget: minBudget,
        maxBudget: maxBudget,
        deadlineFrom: deadlineFrom,
        deadlineTo: deadlineTo,
      );
      _mergeJobTypes(data);
      emit(state.copyWith(
        data: data,
        loading: false,
        jobTypes: Map.from(_jobTypes),
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  // إعادة الجلب بكل الفلاتر المخزّنة
  Future<void> _refetch() => fetchJobsInternship(
        search: _search,
        categoryId: _categoryId,
        jobType: _jobType,
        minBudget: _minBudget,
        maxBudget: _maxBudget,
        deadlineFrom: _deadlineFrom,
        deadlineTo: _deadlineTo,
      );

  void applySearch(String search) {
    _search = search;
    _refetch();
  }

  // setters تحدّث فلتر واحد وتحافظ على الباقي ثم تعيد الجلب
  void setJobType(String? value) {
    _jobType = value;
    _refetch();
  }

  void setBudgetRange(String? min, String? max) {
    _minBudget = min;
    _maxBudget = max;
    _refetch();
  }

  void setDeadlineTo(String? value) {
    _deadlineTo = value;
    _refetch();
  }
}
