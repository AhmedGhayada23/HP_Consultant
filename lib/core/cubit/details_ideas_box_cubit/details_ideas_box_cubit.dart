import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_ideas_box_cubit/details_ideas_box_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsIdeasBoxCubit extends Cubit<DetailsIdeasBoxState> {
  // consultant: يستخدم endpoint قسم الاستشاري (/api/consultant/...)
  final bool consultant;
  DetailsIdeasBoxCubit({this.consultant = false})
      : super(DetailsIdeasBoxState());

  int _ideaId = 0;
  int get ideaId => _ideaId;

  Future<void> fetchDetailsIdeasBox(int id) async {
    _ideaId = id;
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = consultant
          ? await UseCases.getDetailsIdeasBoxConsultantUsecase(id)
          : await UseCases.getDetailsIdeasBoxUsecase(id);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> refresh() => fetchDetailsIdeasBox(_ideaId);
}
