import 'package:flutter/material.dart';
import 'package:hb/core/data/models/details_consultant_meeting_request_model.dart';
import 'package:hb/core/domain/repository/details_consultant_meeting_request_repository.dart';

class DetailsConsultantMeetingRequestUsecase {
  final DetailsConsultantMeetingRequestRepository repository;

  DetailsConsultantMeetingRequestUsecase(this.repository);

  Future<DetailsConsultantMeetingRequestModel> call(int id) async {
    return await repository.getDetailsConsultantMeetingRequest(id);
  }

  Future<void> cancelMeetingRequest(BuildContext context, int id) {
    return repository.cancelMeetingRequest(context,id);
  }
}
