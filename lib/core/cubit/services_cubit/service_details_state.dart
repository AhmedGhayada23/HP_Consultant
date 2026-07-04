import 'package:hb/core/data/models/service_model.dart';

class ServiceDetailsState {
  final ServiceModel? service;
  final bool loading;
  final String? errorMessage;

  ServiceDetailsState({this.service, this.loading = false, this.errorMessage});

  ServiceDetailsState copyWith({
    ServiceModel? service,
    bool? loading,
    String? errorMessage,
  }) {
    return ServiceDetailsState(
      service: service ?? this.service,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
