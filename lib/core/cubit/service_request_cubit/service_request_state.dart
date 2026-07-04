import 'package:hb/core/data/models/service_type_model.dart';

class ServiceRequestState {
  final bool loading;
  final bool success;
  final bool allowReview;
  final String? errorMessage;

  // Service types (dropdown)
  final List<ServiceTypeModel>? serviceTypes;
  final bool serviceTypesLoading;
  final int? selectedServiceTypeId;

  ServiceRequestState({
    this.loading = false,
    this.success = false,
    this.allowReview = false,
    this.errorMessage,
    this.serviceTypes,
    this.serviceTypesLoading = false,
    this.selectedServiceTypeId,
  });

  ServiceRequestState copyWith({
    bool? loading,
    bool? success,
    bool? allowReview,
    String? errorMessage,
    List<ServiceTypeModel>? serviceTypes,
    bool? serviceTypesLoading,
    int? selectedServiceTypeId,
  }) {
    return ServiceRequestState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      allowReview: allowReview ?? this.allowReview,
      errorMessage: errorMessage ?? this.errorMessage,
      serviceTypes: serviceTypes ?? this.serviceTypes,
      serviceTypesLoading: serviceTypesLoading ?? this.serviceTypesLoading,
      selectedServiceTypeId:
          selectedServiceTypeId ?? this.selectedServiceTypeId,
    );
  }
}
