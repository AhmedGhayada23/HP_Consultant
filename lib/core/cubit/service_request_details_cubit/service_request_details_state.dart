import 'package:hb/core/data/models/service_request_item_model.dart';

class ServiceRequestDetailsState {
  final ServiceRequestItemModel? data;
  final bool loading;
  final bool cancelling;
  final String? errorMessage;

  ServiceRequestDetailsState({
    this.data,
    this.loading = false,
    this.cancelling = false,
    this.errorMessage,
  });

  ServiceRequestDetailsState copyWith({
    ServiceRequestItemModel? data,
    bool? loading,
    bool? cancelling,
    String? errorMessage,
  }) {
    return ServiceRequestDetailsState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      cancelling: cancelling ?? this.cancelling,
      errorMessage: errorMessage,
    );
  }
}
