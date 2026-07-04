import 'package:file_picker/file_picker.dart';
import 'package:hb/core/data/models/service_request_item_model.dart';
import 'package:hb/core/domain/repository/service_request_repository.dart';

class GetServiceRequestsUsecase {
  final ServiceRequestRepository repository;
  GetServiceRequestsUsecase(this.repository);

  Future<List<ServiceRequestItemModel>> call({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) {
    return repository.getServiceRequests(
      search: search,
      status: status,
      perPage: perPage,
      page: page,
    );
  }
}

class GetServiceRequestDetailsUsecase {
  final ServiceRequestRepository repository;
  GetServiceRequestDetailsUsecase(this.repository);

  Future<ServiceRequestItemModel> call(int id) =>
      repository.getServiceRequestDetails(id);
}

class UpdateServiceRequestUsecase {
  final ServiceRequestRepository repository;
  UpdateServiceRequestUsecase(this.repository);

  Future<void> call({
    required int id,
    required String description,
    required String proposedBudget,
    String? preferredDeadline,
    List<int> deletedFileIds = const [],
  }) {
    return repository.updateServiceRequest(
      id: id,
      description: description,
      proposedBudget: proposedBudget,
      preferredDeadline: preferredDeadline,
      deletedFileIds: deletedFileIds,
    );
  }
}

class UploadServiceRequestFilesUsecase {
  final ServiceRequestRepository repository;
  UploadServiceRequestFilesUsecase(this.repository);

  Future<void> call({
    required int id,
    required List<PlatformFile> files,
  }) {
    return repository.uploadServiceRequestFiles(id: id, files: files);
  }
}

class CancelServiceRequestUsecase {
  final ServiceRequestRepository repository;
  CancelServiceRequestUsecase(this.repository);

  Future<void> call(int id) => repository.cancelServiceRequest(id);
}

class CreateServiceRequestUsecase {
  final ServiceRequestRepository repository;
  CreateServiceRequestUsecase(this.repository);

  Future<void> call({
    required int serviceId,
    required String preferredDeadline,
    required String proposedBudget,
    required String description,
    required bool allowAdminReview,
    required List<PlatformFile> documents,
  }) {
    return repository.createServiceRequest(
      serviceId: serviceId,
      preferredDeadline: preferredDeadline,
      proposedBudget: proposedBudget,
      description: description,
      allowAdminReview: allowAdminReview,
      documents: documents,
    );
  }
}
