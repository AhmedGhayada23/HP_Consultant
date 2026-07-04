import 'dart:async';

import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/consultant_category_model.dart';
import 'package:hb/core/data/models/consultant_model.dart';
import 'package:hb/core/data/models/consultant_profile_details_model.dart';

abstract class ConsultantRemoteDataSource {
  Future<List<ConsultantModel>> getConsultants({
    String? search,
    String? category,
    String? minBudget,
    String? maxBudget,
    String? availability,
    int perPage,
    int page,
  });
  Future<ConsultantProfileDetailsModel> getConsultantDetails(int id);
  Future<List<ConsultantCategoryModel>> getConsultantCategories();

  /// يرجّع رابط الـ CV، أو يرمي استثناء برسالة السيرفر إن لم يكن متاحًا
  Future<String> getConsultantCvUrl(int id, {bool directory});
}

class ConsultantRemoteDataSourceImpl extends ConsultantRemoteDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<ConsultantModel>> getConsultants({
    String? search,
    String? category,
    String? minBudget,
    String? maxBudget,
    String? availability,
    int perPage = 12,
    int page = 1,
  }) async {
    final response = await _dio.get(
      Constants.consultantsDirectoryUrl,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
        if (minBudget != null && minBudget.isNotEmpty) 'min_budget': minBudget,
        if (maxBudget != null && maxBudget.isNotEmpty) 'max_budget': maxBudget,
        'availability': (availability == null || availability.isEmpty)
            ? 'all'
            : availability,
        'per_page': perPage,
        'page': page,
      },
    );
    final data = response.data;
    if (data == null) return [];
    final List list = data['data'] ?? data ?? [];
    return list
        .whereType<Map>()
        .map((e) => ConsultantModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<ConsultantCategoryModel>> getConsultantCategories() async {
    final response = await _dio.get(Constants.consultantCategoriesUrl);
    final data = response.data;
    if (data == null) return [];
    final List list = data['data'] ?? data ?? [];
    return list
        .whereType<Map>()
        .map((e) =>
            ConsultantCategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<String> getConsultantCvUrl(int id, {bool directory = true}) async {
    final base = directory
        ? Constants.consultantsDirectoryUrl
        : Constants.consultantsUrl;
    final response = await _dio.get('$base/$id/download-cv');
    final data = response.data;
    if (data is Map) {
      if (data['status'] == false) {
        throw Exception(data['message'] ?? 'Consultant CV not available.');
      }
      final d = data['data'];
      if (d is String && d.isNotEmpty) return d;
      if (d is Map) {
        final url = d['url'] ?? d['cv_url'] ?? d['file_url'] ?? d['download_url'];
        if (url != null && url.toString().isNotEmpty) return url.toString();
      }
      throw Exception(data['message'] ?? 'Consultant CV not available.');
    }
    throw Exception('Consultant CV not available.');
  }

  @override
  Future<ConsultantProfileDetailsModel> getConsultantDetails(int id) async {
    final response =
        await _dio.get('${Constants.consultantsDirectoryUrl}/$id');
    final data = response.data;
    final json = data is Map ? (data['data'] ?? data) : {};
    return ConsultantProfileDetailsModel.fromJson(
        Map<String, dynamic>.from(json as Map));
  }
}
