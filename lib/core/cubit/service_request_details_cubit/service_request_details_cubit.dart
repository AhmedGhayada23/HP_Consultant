import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/service_request_details_cubit/service_request_details_state.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ServiceRequestDetailsCubit extends Cubit<ServiceRequestDetailsState> {
  final int requestId;

  ServiceRequestDetailsCubit({required this.requestId})
      : super(ServiceRequestDetailsState(loading: false));

  Future<void> fetchDetails() async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getServiceRequestDetailsUsecase(requestId);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  // إلغاء الطلب ثم تحديث التفاصيل عند النجاح
  Future<void> cancelRequest(BuildContext context) async {
    emit(state.copyWith(cancelling: true, errorMessage: null));
    try {
      await UseCases.cancelServiceRequestUsecase(requestId);
      emit(state.copyWith(cancelling: false));
      await fetchDetails();
    } catch (e) {
      emit(state.copyWith(cancelling: false, errorMessage: e.toString()));
      if (context.mounted) {
        showCustomSnackBar(context, e.toString(), SnackBarType.error);
      }
    }
  }
}
