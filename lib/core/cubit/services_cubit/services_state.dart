import 'package:hb/core/data/models/service_model.dart';

class ServicesState {
  final List<ServiceModel>? data;
  final bool? loading;
  final String? errorMessage;
  final String search;
  final String status;

  ServicesState({
    this.data,
    this.loading,
    this.errorMessage,
    this.search = '',
    this.status = 'all',
  });

  ServicesState copyWith({
    List<ServiceModel>? data,
    bool? loading,
    String? errorMessage,
    String? search,
    String? status,
  }) {
    return ServicesState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      search: search ?? this.search,
      status: status ?? this.status,
    );
  }
}
