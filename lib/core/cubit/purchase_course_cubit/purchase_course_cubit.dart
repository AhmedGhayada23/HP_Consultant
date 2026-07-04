import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/purchase_course_cubit/purchase_course_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class PurchaseCourseCubit extends Cubit<PurchaseCourseState> {
  PurchaseCourseCubit() : super(PurchaseCourseState());

  Future<void> purchaseCourse(BuildContext context,int courseId) async {
    // ✅ شغّل loading بس على هاد العنصر
    emit(state.copyWith(loadingCourseId: courseId, errorMessage: null));

    try {
      await UseCases.getTrainingCoursesUsecase.purchaseCourse(context,courseId: courseId);
      emit(state.copyWith(clearLoading: true, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(clearLoading: true, errorMessage: e.toString()));
    }
  }
}
