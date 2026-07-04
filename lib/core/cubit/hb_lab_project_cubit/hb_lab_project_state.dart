import 'package:hb/core/data/models/hb_lab_project_model.dart';

class HbLabProjectState {
  final List<HbLabProjectModel> data;
  final bool loading;
  final bool loadingMore;
  final int currentPage;
  final int lastPage;
  final int total;
  final String? errorMessage;

  HbLabProjectState({
    this.data = const [],
    this.loading = false,
    this.loadingMore = false,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.errorMessage,
  });

  bool get hasMore => currentPage < lastPage;

  HbLabProjectState copyWith({
    List<HbLabProjectModel>? data,
    bool? loading,
    bool? loadingMore,
    int? currentPage,
    int? lastPage,
    int? total,
    String? errorMessage,
  }) {
    return HbLabProjectState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      errorMessage: errorMessage,
    );
  }
}
