import 'package:hb/core/data/models/consultant_meeting_request_modle.dart';

class ConsultantMeetingRequestState {
  final List<ConsultantMeetingRequestModel>? data;
  final bool? loading;
  final String? errorMessage;

  ConsultantMeetingRequestState({this.data, this.loading, this.errorMessage});

  ConsultantMeetingRequestState copyWith({
    List<ConsultantMeetingRequestModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return ConsultantMeetingRequestState(
      data:  data ?? this.data,
      loading:  loading ?? this.loading,
      errorMessage:  errorMessage ?? this.errorMessage
    );
  }
}
