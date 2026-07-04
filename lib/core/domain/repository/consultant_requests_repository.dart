import 'package:file_picker/file_picker.dart';
import 'package:hb/core/data/datasource/consultant_requests_remote_datasource.dart';
import 'package:hb/core/data/models/consultant_request_model.dart';

abstract class ConsultantRequestsRepository {
  Future<List<ConsultantRequestModel>> getConsultantRequests({
    String? search,
    String? status,
    int perPage,
    int page,
  });
  Future<void> createConsultantRequest({
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
  });
}

class ConsultantRequestsRepositoryImpl implements ConsultantRequestsRepository {
  final ConsultantRequestsRemoteDataSource remoteDataSource;

  ConsultantRequestsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ConsultantRequestModel>> getConsultantRequests({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) =>
      remoteDataSource.getConsultantRequests(
        search: search,
        status: status,
        perPage: perPage,
        page: page,
      );

  @override
  Future<void> createConsultantRequest({
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
      remoteDataSource.createConsultantRequest(
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
