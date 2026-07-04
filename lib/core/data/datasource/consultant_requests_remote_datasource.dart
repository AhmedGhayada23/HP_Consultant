import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/consultant_request_model.dart';

abstract class ConsultantRequestsRemoteDataSource {
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

class ConsultantRequestsRemoteDataSourceImpl
    implements ConsultantRequestsRemoteDataSource {
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
  Future<List<ConsultantRequestModel>> getConsultantRequests({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _dio.get(
      Constants.consultantRequestsUrl,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        'status': (status == null || status.isEmpty) ? 'all' : status,
        'per_page': perPage,
        'page': page,
      },
    );
    final data = response.data;
    if (data == null) return [];
    final List list = data['data'] ?? data ?? [];
    return list
        .whereType<Map>()
        .map((e) =>
            ConsultantRequestModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

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
  }) async {
    final formData = FormData.fromMap({
      'service_id': serviceId,
      'consultant_id': consultantId,
      'project_title': projectTitle,
      'preferred_deadline': preferredDeadline,
      'pricing_type': pricingType,
      'proposed_budget': proposedBudget,
      'priority': priority,
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
      Constants.consultantRequestsUrl,
      data: formData,
    );
    _throwIfError(response);
  }
}
