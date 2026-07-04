import 'package:hb/core/data/datasource/schedule_interview_data_source.dart';

abstract class ScheduleInterviewRepository {
  Future<void> scheduleInterview({
    required int applicationId,
    required String meetingTitle,
    required String meetingDate,
    required String meetingTime,
    required String meetingLink,
  });
}

class ScheduleInterviewRepositoryImpl extends ScheduleInterviewRepository {
  final ScheduleInterviewDataSource dataSource;
  ScheduleInterviewRepositoryImpl(this.dataSource);

  @override
  Future<void> scheduleInterview({
    required int applicationId,
    required String meetingTitle,
    required String meetingDate,
    required String meetingTime,
    required String meetingLink,
  }) {
    return dataSource.scheduleInterview(
      applicationId: applicationId,
      meetingTitle: meetingTitle,
      meetingDate: meetingDate,
      meetingTime: meetingTime,
      meetingLink: meetingLink,
    );
  }
}
