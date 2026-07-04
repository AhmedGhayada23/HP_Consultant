import 'package:hb/core/data/models/hb_lab_ideas_box_model.dart';

class HbLabIdeasBoxState {
  final List<HbLabIdeasBoxModel> data;
  final bool loading;
  final bool loadingMore;
  final int currentPage;
  final int lastPage;
  final int total;
  final String? errorMessage;

  HbLabIdeasBoxState({
    this.data = const [],
    this.loading = false,
    this.loadingMore = false,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.errorMessage,
  });

  bool get hasMore => currentPage < lastPage;

  HbLabIdeasBoxState copyWith({
    List<HbLabIdeasBoxModel>? data,
    bool? loading,
    bool? loadingMore,
    int? currentPage,
    int? lastPage,
    int? total,
    String? errorMessage,
  }) {
    return HbLabIdeasBoxState(
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
