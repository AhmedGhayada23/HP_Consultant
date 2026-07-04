import 'package:hb/core/data/models/service_type_model.dart';

class RequestConsultantState {
  final bool isLoading;
  final String? errorMessage;
  final bool isRequestSuccessful;
  final bool allowReview;

  // Service types (dropdown)
  final List<ServiceTypeModel>? serviceTypes;
  final bool serviceTypesLoading;
  final int? selectedServiceTypeId;

  RequestConsultantState({
    this.isLoading = false,
    this.errorMessage,
    this.isRequestSuccessful = false,
    this.allowReview = false,
    this.serviceTypes,
    this.serviceTypesLoading = false,
    this.selectedServiceTypeId,
  });

  RequestConsultantState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isRequestSuccessful,
    bool? allowReview,
    List<ServiceTypeModel>? serviceTypes,
    bool? serviceTypesLoading,
    int? selectedServiceTypeId,
  }) {
    return RequestConsultantState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isRequestSuccessful: isRequestSuccessful ?? this.isRequestSuccessful,
      allowReview: allowReview ?? this.allowReview,
      serviceTypes: serviceTypes ?? this.serviceTypes,
      serviceTypesLoading: serviceTypesLoading ?? this.serviceTypesLoading,
      selectedServiceTypeId:
          selectedServiceTypeId ?? this.selectedServiceTypeId,
    );
  }
}
