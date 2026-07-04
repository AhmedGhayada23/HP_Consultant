import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/service_request_item_model.dart';

abstract class ServiceRequestRemoteDataSource {
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

class ServiceRequestRemoteDataSourceImpl
    implements ServiceRequestRemoteDataSource {
  final _dio = RemoteConnectionDio().dio;

  void _throwIfError(Response response) {
    final status = response.statusCode ?? 0;
    if (status >= 400) {
      final msg = response.data is Map
          ? (response.data['message'] ?? 'Server error $status')
          : 'Server error $status';
      throw Exception(msg);
    }
  }

  @override
  Future<List<ServiceRequestItemModel>> getServiceRequests({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _dio.get(
      Constants.serviceRequestsUrl,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty && status != 'all')
          'status': status,
        'per_page': perPage,
        'page': page,
      },
    );
    _throwIfError(response);
    final data = response.data;
    if (data == null) return [];
    final List list = data['data'] ?? data ?? [];
    return list
        .whereType<Map>()
        .map((e) =>
            ServiceRequestItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<ServiceRequestItemModel> getServiceRequestDetails(int id) async {
    final response = await _dio.get('${Constants.serviceRequestsUrl}/$id');
    _throwIfError(response);
    final data = response.data;
    final json = data is Map ? (data['data'] ?? data) : {};
    return ServiceRequestItemModel.fromJson(
        Map<String, dynamic>.from(json as Map));
  }

  @override
  Future<void> updateServiceRequest({
    required int id,
    required String description,
    required String proposedBudget,
    String? preferredDeadline,
    List<int> deletedFileIds = const [],
  }) async {
    final formData = FormData.fromMap({
      'description': description,
      'proposed_budget': proposedBudget,
      if (preferredDeadline != null && preferredDeadline.isNotEmpty)
        'preferred_deadline': preferredDeadline,
    });
    // معرّفات الملفات المحذوفة
    for (final fid in deletedFileIds) {
      formData.fields.add(MapEntry('deleted_files[]', fid.toString()));
    }
    final response = await _dio.patch(
      '${Constants.serviceRequestsUrl}/$id',
      data: formData,
    );
    _throwIfError(response);
  }

  @override
  Future<void> uploadServiceRequestFiles({
    required int id,
    required List<PlatformFile> files,
  }) async {
    final formData = FormData();
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      if (file.path != null) {
        formData.files.add(
          MapEntry(
            'files[$i]',
            await MultipartFile.fromFile(file.path!, filename: file.name),
          ),
        );
      }
    }
    final response = await _dio.post(
      '${Constants.serviceRequestsUrl}/$id/files',
      data: formData,
    );
    _throwIfError(response);
  }

  @override
  Future<void> cancelServiceRequest(int id) async {
    final response = await _dio.post('${Constants.serviceRequestsUrl}/$id/cancel');
    _throwIfError(response);
    final data = response.data;
    if (data is Map && data['status'] == false) {
      throw Exception(data['message'] ?? 'Failed to cancel service request');
    }
  }

  @override
  Future<void> createServiceRequest({
    required int serviceId,
    required String preferredDeadline,
    required String proposedBudget,
    required String description,
    required bool allowAdminReview,
    required List<PlatformFile> documents,
  }) async {
    final formData = FormData.fromMap({
      'service_id': serviceId,
      'preferred_deadline': preferredDeadline,
      'proposed_budget': proposedBudget,
      'description': description,
      'allow_admin_review': allowAdminReview ? 1 : 0,
    });

    for (int i = 0; i < documents.length; i++) {
      final file = documents[i];
      if (file.path != null) {
        formData.files.add(
          MapEntry(
            'supporting_documents[$i]',
            await MultipartFile.fromFile(file.path!, filename: file.name),
          ),
        );
      }
    }

    final response = await _dio.post(
      Constants.serviceRequestsUrl,
      data: formData,
    );
    _throwIfError(response);
  }
}
