import 'package:hb/core/domain/repository/schedule_interview_repository.dart';

class ScheduleInterviewUsecase {
  final ScheduleInterviewRepository repository;
  ScheduleInterviewUsecase(this.repository);

  Future<void> call({
    required int applicationId,
    required String meetingTitle,
    required String meetingDate,
    required String meetingTime,
    required String meetingLink,
  }) {
    return repository.scheduleInterview(
      applicationId: applicationId,
      meetingTitle: meetingTitle,
      meetingDate: meetingDate,
      meetingTime: meetingTime,
      meetingLink: meetingLink,
    );
  }
}
