import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/hb_lab_ideas_box_cubit/hb_lab_ideas_box_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class HbLabIdeasBoxCubit extends Cubit<HbLabIdeasBoxState> {
  HbLabIdeasBoxCubit() : super(HbLabIdeasBoxState());

  String? _lastSearch;
  Map<String, dynamic> _lastFilters = {};

  Future<void> fetchHbLabIdeasBox({
    String? search,
    Map<String, dynamic>? filters,
  }) async {
    _lastSearch = search;
    if (filters != null) _lastFilters = filters;
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final result = await UseCases.getHbLabIdeasBoxUsecase(
        search: _lastSearch,
        page: 1,
        filters: _lastFilters.isEmpty ? null : _lastFilters,
      );
      emit(state.copyWith(
        data: result.ideas,
        loading: false,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        total: result.total,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> toggleUpvote(int id) async {
    try {
      final result = await UseCases.getHbLabUpvoteConsultantUsecase(id);
      final updated = state.data.map((item) {
        if (item.id == id) {
          return item.copyWith(
            userHasUpvoted: result.upvoted,
            votesCount: result.votesCount,
          );
        }
        return item;
      }).toList();
      emit(state.copyWith(data: updated));
    } catch (_) {}
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore) return;
    emit(state.copyWith(loadingMore: true));

    try {
      final result = await UseCases.getHbLabIdeasBoxUsecase(
        search: _lastSearch,
        page: state.currentPage + 1,
        filters: _lastFilters.isEmpty ? null : _lastFilters,
      );
      emit(state.copyWith(
        data: [...state.data, ...result.ideas],
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
