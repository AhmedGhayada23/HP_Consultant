import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/hb_lab_join_cubit/hb_lab_join_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class HbLabJoinCubit extends Cubit<HbLabJoinState> {
  // consultant: يستخدم endpoint قسم الاستشاري (/api/consultant/...)
  final bool consultant;
  HbLabJoinCubit({this.consultant = false}) : super(HbLabJoinState());

  Future<void> joinProject({
    required BuildContext context,
    required int projectId,
    required String message,
    required String expertise,
  }) async {
    emit(state.copyWith(loading: true, success: false));
    try {
      final usecase = consultant
          ? UseCases.getHbLabJoinConsultantUsecase
          : UseCases.getHbLabJoinUsecase;
      final success = await usecase(
        context: context,
        projectId: projectId,
        message: message,
        expertise: expertise,
      );
      emit(state.copyWith(loading: false, success: success));
    } catch (e) {
      emit(state.copyWith(loading: false));
    }
  }
}
