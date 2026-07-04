import 'package:flutter/material.dart';
import 'package:hb/core/data/datasource/details_consultant_meeting_request_data_source.dart';
import 'package:hb/core/data/models/details_consultant_meeting_request_model.dart';

abstract class DetailsConsultantMeetingRequestRepository {
  Future<DetailsConsultantMeetingRequestModel> getDetailsConsultantMeetingRequest(int id);
  Future<void> cancelMeetingRequest(BuildContext context, int id);
}

class DetailsConsultantMeetingRequestRepositoryImpl
    extends DetailsConsultantMeetingRequestRepository {
  final DetailsConsultantMeetingRequestDataSource dataSource;
  DetailsConsultantMeetingRequestRepositoryImpl(this.dataSource);

  @override
  Future<DetailsConsultantMeetingRequestModel> getDetailsConsultantMeetingRequest(int id) {
    return dataSource.getDetailsConsultantMeetingRequest(id);
  }

  @override
  Future<void> cancelMeetingRequest(BuildContext context, int id) {
    return dataSource.cancelMeetingRequest(context,id);
  }
}
