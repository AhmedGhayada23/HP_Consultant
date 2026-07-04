import 'package:hb/core/data/models/dashboard_campany_model.dart';

class DashboardCampanyState {
  final DashboardCampanyModel? dashboardCampanyModel;
  final bool? isLoading;
  final String? errorMessage;

  DashboardCampanyState({this.dashboardCampanyModel, this.isLoading, this.errorMessage});

  DashboardCampanyState copyWith({
    DashboardCampanyModel? dashboardCampanyModel,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DashboardCampanyState(
      dashboardCampanyModel: dashboardCampanyModel ?? this.dashboardCampanyModel,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
