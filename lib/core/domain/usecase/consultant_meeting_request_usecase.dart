import 'package:flutter/material.dart';
import 'package:hb/core/data/models/consultant_meeting_request_modle.dart';
import 'package:hb/core/domain/repository/consultant_meeting_request_repository.dart';

class ConsultantMeetingRequestUsecase {
  final ConsultantMeetingRequestRepository repository;

  ConsultantMeetingRequestUsecase(this.repository);

  Future<List<ConsultantMeetingRequestModel>> call({
    String? category,
    String? status,
    String? name,
  }) async {
    return await repository.getConsultantMeetingRequest(
      category: category,
      status: status,
      name: name,
    );
  }

  Future<void> addMeetingRequests({
    BuildContext? context,
    required Map<String, dynamic> meetingData,
  }) async {
    return await repository.addMeetingRequests(context: context, meetingData: meetingData);
  }
}
