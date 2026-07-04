import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/add_comment_cubit/add_comment_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class AddCommentCubit extends Cubit<AddCommentState> {
  // consultant: يستخدم endpoint قسم الاستشاري (/api/consultant/...)
  final bool consultant;
  AddCommentCubit({this.consultant = false}) : super(AddCommentState());

  Future<void> addComment({required int ideaId, required String body}) async {
    emit(state.copyWith(loading: true, success: false));
    try {
      final usecase = consultant
          ? UseCases.getHbLabCommentConsultantUsecase
          : UseCases.getHbLabCommentUsecase;
      final success = await usecase(
        ideaId: ideaId,
        body: body,
      );
      emit(state.copyWith(loading: false, success: success));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
