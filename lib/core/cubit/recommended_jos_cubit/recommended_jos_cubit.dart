import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/recommended_jos_cubit/recommended_jos_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class RecommendedJosCubit extends Cubit<RecommendedJosState> {
  RecommendedJosCubit() : super(const RecommendedJosState());

  String? _lastSearch;
  Map<String, dynamic> _lastFilters = {};

  Future<void> fetchRecommendedJos({
    String? search,
    Map<String, dynamic>? filters,
  }) async {
    _lastSearch = search;
    if (filters != null) _lastFilters = filters;
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final response = await UseCases.getRecommendedJosUsecase(
        search: _lastSearch,
        page: 1,
        filters: _lastFilters.isEmpty ? null : _lastFilters,
      );
      emit(state.copyWith(
        data: response.jobs,
        loading: false,
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        total: response.total,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore) return;
    emit(state.copyWith(loadingMore: true));
    try {
      final response = await UseCases.getRecommendedJosUsecase(
        search: _lastSearch,
        page: state.currentPage + 1,
        filters: _lastFilters.isEmpty ? null : _lastFilters,
      );
      emit(state.copyWith(
        data: [...state.data, ...response.jobs],
        loadingMore: false,
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        total: response.total,
      ));
    } catch (e) {
      emit(state.copyWith(loadingMore: false, errorMessage: e.toString()));
    }
  }
}
