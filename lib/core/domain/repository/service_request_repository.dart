import 'package:file_picker/file_picker.dart';
import 'package:hb/core/data/datasource/service_request_remote_datasource.dart';
import 'package:hb/core/data/models/service_request_item_model.dart';

abstract class ServiceRequestRepository {
  Future<List<ServiceRequestItemModel>> getServiceRequests({
    String? search,
    String? status,
    int perPage,
    int page,
  });
  Future<ServiceRequestItemModel> getServiceRequestDetails(int id);
  Future<void> updateServiceRequest({
    required int id,
    required String description,
    required String proposedBudget,
    String? preferredDeadline,
    List<int> deletedFileIds,
  });
  Future<void> uploadServiceRequestFiles({
    required int id,
    required List<PlatformFile> files,
  });
  Future<void> cancelServiceRequest(int id);
  Future<void> createServiceRequest({
    required int serviceId,
    required String preferredDeadline,
    required String proposedBudget,
    required String description,
    required bool allowAdminReview,
    required List<PlatformFile> documents,
  });
}

class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final ServiceRequestRemoteDataSource remoteDataSource;

  ServiceRequestRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ServiceRequestItemModel>> getServiceRequests({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) {
    return remoteDataSource.getServiceRequests(
      search: search,
      status: status,
      perPage: perPage,
      page: page,
    );
  }

  @override
  Future<ServiceRequestItemModel> getServiceRequestDetails(int id) =>
      remoteDataSource.getServiceRequestDetails(id);

  @override
  Future<void> updateServiceRequest({
    required int id,
    required String description,
    required String proposedBudget,
    String? preferredDeadline,
    List<int> deletedFileIds = const [],
  }) {
    return remoteDataSource.updateServiceRequest(
      id: id,
      description: description,
      proposedBudget: proposedBudget,
      preferredDeadline: preferredDeadline,
      deletedFileIds: deletedFileIds,
    );
  }

  @override
  Future<void> uploadServiceRequestFiles({
    required int id,
    required List<PlatformFile> files,
  }) {
    return remoteDataSource.uploadServiceRequestFiles(id: id, files: files);
  }

  @override
  Future<void> cancelServiceRequest(int id) =>
      remoteDataSource.cancelServiceRequest(id);

  @override
  Future<void> createServiceRequest({
    required int serviceId,
    required String preferredDeadline,
    required String proposedBudget,
    required String description,
    required bool allowAdminReview,
    required List<PlatformFile> documents,
  }) {
    return remoteDataSource.createServiceRequest(
      serviceId: serviceId,
      preferredDeadline: preferredDeadline,
      proposedBudget: proposedBudget,
      description: description,
      allowAdminReview: allowAdminReview,
      documents: documents,
    );
  }
}
