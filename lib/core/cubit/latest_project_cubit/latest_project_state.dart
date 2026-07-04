import 'package:hb/core/data/models/recent_invoice_model.dart';

class LatestProjectState {
  final List<RecentInvoiceModel>? latestProjectData;
  final bool loading;
  final String? errorMessage;

  LatestProjectState({
     this.latestProjectData,
     this.loading = false,
     this.errorMessage,
  });

  LatestProjectState copyWith({
    List<RecentInvoiceModel>? latestProjectData,
    bool? loading,
    String? errorMessage,
  }) {
    return LatestProjectState(
      latestProjectData: latestProjectData ?? this.latestProjectData,
      loading: loading ?? this.loading,
      errorMessage:  errorMessage ?? this.errorMessage,
    );
  }
}
