import 'package:hb/core/data/models/consultant_dashboard_model.dart';

class ConsultantDashboardState {
  final ConsultantDashboardModel? data;
  final bool loading;
  final String? errorMessage;

  ConsultantDashboardState({this.data, this.loading = false, this.errorMessage});

  ConsultantDashboardState copyWith({
    ConsultantDashboardModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return ConsultantDashboardState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}
