import 'package:file_picker/file_picker.dart';
import 'package:hb/core/data/models/consultant_request_model.dart';
import 'package:hb/core/domain/repository/consultant_requests_repository.dart';

class ConsultantRequestsUsecase {
  final ConsultantRequestsRepository repository;
  ConsultantRequestsUsecase(this.repository);

  Future<List<ConsultantRequestModel>> call({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) =>
      repository.getConsultantRequests(
        search: search,
        status: status,
        perPage: perPage,
        page: page,
      );
}

class CreateConsultantRequestUsecase {
  final ConsultantRequestsRepository repository;
  CreateConsultantRequestUsecase(this.repository);

  Future<void> call({
    required int serviceId,
    required int consultantId,
    required String projectTitle,
    required String preferredDeadline,
    required String pricingType,
    required String proposedBudget,
    required String priority,
    required String description,
    required bool allowAdminReview,
    required List<PlatformFile> documents,
  }) =>
      repository.createConsultantRequest(
        serviceId: serviceId,
        consultantId: consultantId,
        projectTitle: projectTitle,
        preferredDeadline: preferredDeadline,
        pricingType: pricingType,
        proposedBudget: proposedBudget,
        priority: priority,
        description: description,
        allowAdminReview: allowAdminReview,
        documents: documents,
      );
}
