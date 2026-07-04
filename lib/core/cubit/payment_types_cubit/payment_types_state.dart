import 'package:hb/core/data/models/payment_types_model.dart';

class PaymentTypesState {
  final List<PaymentTypesModel>? paymentTypes;
  final String? selectedPaymentType;
  final bool isLoading;
  final String? errorMessage;

  PaymentTypesState({
    this.paymentTypes,
    this.selectedPaymentType,
    this.isLoading = false,
    this.errorMessage,
  });

  PaymentTypesState copyWith({
    List<PaymentTypesModel>? paymentTypes,
    String? selectedPaymentType,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PaymentTypesState(
      paymentTypes: paymentTypes ?? this.paymentTypes,
      selectedPaymentType: selectedPaymentType ?? this.selectedPaymentType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
