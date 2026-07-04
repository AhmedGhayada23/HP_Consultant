import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/employee_developer_cubit/purchased_course_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class PurchasedCourseCubit extends Cubit<PurchasedCourseSate> {
  PurchasedCourseCubit() : super(PurchasedCourseSate());
 final TextEditingController timelineTextEditingController = TextEditingController();

  Future<void> fetchEmployeeDeveloper({String? status, String? search, String? timeline}) async {
    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final data = await UseCases.getPurchasedCourseUsecase(
        search: search,
        status: status,
        timeline: timeline,
      );
      emit(state.copyWith(purchasedCourseModle: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
