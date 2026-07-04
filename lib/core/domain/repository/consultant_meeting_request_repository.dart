import 'package:flutter/material.dart';
import 'package:hb/core/data/datasource/consultant_meeting_request_data_source.dart';
import 'package:hb/core/data/models/consultant_meeting_request_modle.dart';

abstract class ConsultantMeetingRequestRepository {
  Future<List<ConsultantMeetingRequestModel>> getConsultantMeetingRequest({
    String? category,
    String? status,
    String? name,
  });
  Future<void> addMeetingRequests({
    BuildContext? context,
    required Map<String, dynamic> meetingData,
  });
}

class ConsultantMeetingRequestRepositoryImpl extends ConsultantMeetingRequestRepository {
  final ConsultantMeetingRequestDataSource dataSource;

  ConsultantMeetingRequestRepositoryImpl(this.dataSource);

  @override
  Future<List<ConsultantMeetingRequestModel>> getConsultantMeetingRequest({
    String? category,
    String? status,
    String? name,
  }) {
    return dataSource.getConsultantMeetingRequest(category: category,name: name,status: status);
  }

  @override
  Future<void> addMeetingRequests({
    BuildContext? context,
    required Map<String, dynamic> meetingData,
  }) {
    return dataSource.addMeetingRequests(context: context, meetingData: meetingData);
  }
}
