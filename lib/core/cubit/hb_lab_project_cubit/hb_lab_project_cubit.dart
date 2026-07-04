import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/hb_lab_project_cubit/hb_lab_project_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class HbLabProjectCubit extends Cubit<HbLabProjectState> {
  HbLabProjectCubit() : super(HbLabProjectState());

  String? _lastSearch;
  Map<String, dynamic> _lastFilters = {};

  Future<void> fetchHbLabProject({
    String? search,
    Map<String, dynamic>? filters,
  }) async {
    _lastSearch = search;
    if (filters != null) _lastFilters = filters;
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final result = await UseCases.getHbLabProjectUsecase(
        search: _lastSearch,
        page: 1,
        filters: _lastFilters.isEmpty ? null : _lastFilters,
      );
      emit(state.copyWith(
        data: result.projects,
        loading: false,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        total: result.total,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore) return;
    emit(state.copyWith(loadingMore: true));

    try {
      final result = await UseCases.getHbLabProjectUsecase(
        search: _lastSearch,
        page: state.currentPage + 1,
        filters: _lastFilters.isEmpty ? null : _lastFilters,
      );
      emit(state.copyWith(
        data: [...state.data, ...result.projects],
        loadingMore: false,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        total: result.total,
      ));
    } catch (e) {
      emit(state.copyWith(loadingMore: false));
    }
  }
}
