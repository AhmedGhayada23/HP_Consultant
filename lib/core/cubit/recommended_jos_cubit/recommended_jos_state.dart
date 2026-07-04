import 'package:hb/core/data/models/recommended_jos_model.dart';

class RecommendedJosState {
  final List<RecommendedJobModel> data;
  final bool loading;
  final bool loadingMore;
  final int currentPage;
  final int lastPage;
  final int total;
  final String? errorMessage;

  const RecommendedJosState({
    this.data = const [],
    this.loading = false,
    this.loadingMore = false,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.errorMessage,
  });

  bool get hasMore => currentPage < lastPage;

  RecommendedJosState copyWith({
    List<RecommendedJobModel>? data,
    bool? loading,
    bool? loadingMore,
    int? currentPage,
    int? lastPage,
    int? total,
    String? errorMessage,
  }) {
    return RecommendedJosState(
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
