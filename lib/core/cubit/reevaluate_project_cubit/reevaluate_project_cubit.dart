import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/reevaluate_project_cubit/reevaluate_project_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';

class ReevaluateProjectCubit extends Cubit<ReevaluateProjectState> {
  ReevaluateProjectCubit() : super(ReevaluateProjectState());

  final TextEditingController supportingDocController = TextEditingController();
  final TextEditingController reasonBoostController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void reevaluateProject(BuildContext context) {
    emit(state.copyWith(loading: true, success: false));
    Future.delayed(Duration(seconds: 2), () {
      emit(state.copyWith(loading: false, success: true));
      showCustomSnackBar(context, 'submit in successfully!', SnackBarType.success);
    });
  }
}
