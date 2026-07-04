import 'package:hb/core/data/models/details_consultant_meeting_request_model.dart';

class DetailsConsultantMeetingRequestState {
  final DetailsConsultantMeetingRequestModel? data;
  final bool? loading;
  final String? errorMessage;

  DetailsConsultantMeetingRequestState({this.data, this.loading, this.errorMessage});

  DetailsConsultantMeetingRequestState copyWith({
    DetailsConsultantMeetingRequestModel? data,
    bool? loading,
    String? errorMessage,
  }) {
    return DetailsConsultantMeetingRequestState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
