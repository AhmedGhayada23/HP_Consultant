import 'package:hb/core/data/models/course_model.dart';

class CourseDiscoveryState {
  final List<CourseModel>? courses;
  final bool loading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;
  final int lastPage;
  final Map<int, String> categories; // كل التصنيفات المتراكمة (id -> name)

  bool get hasMore => currentPage < lastPage;

  CourseDiscoveryState({
    this.courses,
    this.loading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentPage = 1,
    this.lastPage = 1,
    this.categories = const {},
  });

  CourseDiscoveryState copyWith({
    List<CourseModel>? courses,
    bool? loading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
    int? lastPage,
    Map<int, String>? categories,
  }) {
    return CourseDiscoveryState(
      courses: courses ?? this.courses,
      loading: loading ?? this.loading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      categories: categories ?? this.categories,
    );
  }
}
