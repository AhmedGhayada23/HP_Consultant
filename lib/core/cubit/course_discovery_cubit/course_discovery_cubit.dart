import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/course_discovery_cubit/course_discovery_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class CourseDiscoveryCubit extends Cubit<CourseDiscoveryState> {
  CourseDiscoveryCubit() : super(CourseDiscoveryState());

  String _search = '';
  String? _level;
  int? _categoryId;

  // كل التصنيفات المتراكمة عبر النداءات (لا تتقلّص عند الفلترة)
  final Map<int, String> _categories = {};

  void _mergeCategories(List courses) {
    for (final c in courses) {
      final cat = c.category;
      if (cat != null && cat.name.isNotEmpty) {
        _categories[cat.id] = cat.name;
      }
    }
  }

  // ── جلب الصفحة الأولى (أو إعادة التحميل بعد تغيير الفلتر) ──────────────
  Future<void> fetchCourseDiscovery() async {
    emit(state.copyWith(loading: true, courses: null, currentPage: 1, lastPage: 1));
    try {
      final result = await UseCases.getCoursesUseCase(
        search: _search,
        level: _level,
        categoryId: _categoryId,
        page: 1,
      );
      _mergeCategories(result.courses);
      emit(state.copyWith(
        courses: result.courses,
        loading: false,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        categories: Map.from(_categories),
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  // ── جلب الصفحة التالية ────────────────────────────────────────────────────
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final result = await UseCases.getCoursesUseCase(
        search: _search,
        level: _level,
        categoryId: _categoryId,
        page: nextPage,
      );
      _mergeCategories(result.courses);
      emit(state.copyWith(
        courses: [...(state.courses ?? []), ...result.courses],
        isLoadingMore: false,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        categories: Map.from(_categories),
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, errorMessage: e.toString()));
    }
  }

  // ── بحث ──────────────────────────────────────────────────────────────────
  void applySearch(String search) {
    _search = search;
    fetchCourseDiscovery();
  }

  // ── فلتر ─────────────────────────────────────────────────────────────────
  void applyFilters({String? level, int? categoryId}) {
    _level = level;
    _categoryId = categoryId;
    fetchCourseDiscovery();
  }

  void clearFilters() {
    _level = null;
    _categoryId = null;
    _search = '';
    fetchCourseDiscovery();
  }
}
