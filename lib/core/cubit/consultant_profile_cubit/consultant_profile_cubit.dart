import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/consultant_profile_cubit/consultant_profile_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ConsultantProfileCubit extends Cubit<ConsultantProfileState> {
  final int consultantId;

  ConsultantProfileCubit({required this.consultantId})
      : super(ConsultantProfileState(loading: false));

  Future<void> fetchProfile() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getConsultantDetailsUsecase(consultantId);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
