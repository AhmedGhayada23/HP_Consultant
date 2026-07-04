import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/payment_types_cubit/payment_types_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class PaymentTypesCubit extends Cubit<PaymentTypesState> {
  PaymentTypesCubit() : super(PaymentTypesState());

  void setPaymentType(String paymentType) {
    emit(state.copyWith(selectedPaymentType: paymentType));
  }

  Future<void> fetchPaymentTypes() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final paymentTypes = await UseCases.getJobAndTalentUsecase.getPaymentTypes();
      emit(state.copyWith(paymentTypes: paymentTypes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void clearPaymentType() {
    // إعادة بناء الحالة لتصفير الاختيار فعليًا (copyWith لا يقبل null)
    emit(PaymentTypesState(
      paymentTypes: state.paymentTypes,
      isLoading: state.isLoading,
    ));
  }
}
