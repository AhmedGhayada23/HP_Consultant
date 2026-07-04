import 'package:hb/core/data/models/consultant_request_model.dart';

class ConsultantRequestsState {
  final List<ConsultantRequestModel>? data;
  final bool? loading;
  final String? errorMessage;
  final String search;
  final String status;

  ConsultantRequestsState({
    this.data,
    this.loading,
    this.errorMessage,
    this.search = '',
    this.status = 'all',
  });

  ConsultantRequestsState copyWith({
    List<ConsultantRequestModel>? data,
    bool? loading,
    String? errorMessage,
    String? search,
    String? status,
  }) {
    return ConsultantRequestsState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      search: search ?? this.search,
      status: status ?? this.status,
    );
  }
}
