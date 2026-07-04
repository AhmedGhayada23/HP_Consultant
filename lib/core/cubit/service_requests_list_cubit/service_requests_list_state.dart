import 'package:hb/core/data/models/service_request_item_model.dart';

class ServiceRequestsListState {
  final List<ServiceRequestItemModel>? data;
  final bool loading;
  final String? errorMessage;
  final String search;
  final String status;

  ServiceRequestsListState({
    this.data,
    this.loading = false,
    this.errorMessage,
    this.search = '',
    this.status = 'all',
  });

  ServiceRequestsListState copyWith({
    List<ServiceRequestItemModel>? data,
    bool? loading,
    String? errorMessage,
    String? search,
    String? status,
  }) {
    return ServiceRequestsListState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      search: search ?? this.search,
      status: status ?? this.status,
    );
  }
}
