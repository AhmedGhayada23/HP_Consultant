import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/service_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ServiceModel>> getServices({
    String? search,
    String? status,
    int perPage,
    int page,
  });
  Future<ServiceModel> getServiceDetails(int id);
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<ServiceModel>> getServices({
    String? search,
    String? status,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _dio.get(
      Constants.servicesUrl,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty && status != 'all')
          'status': status,
        'per_page': perPage,
        'page': page,
      },
    );
    final data = response.data;
    if (data == null) return [];
    final List list = data['data'] ?? data ?? [];
    return list
        .whereType<Map>()
        .map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<ServiceModel> getServiceDetails(int id) async {
    final response = await _dio.get('${Constants.servicesUrl}/$id');
    final data = response.data;
    final json = data is Map ? (data['data'] ?? data) : {};
    return ServiceModel.fromJson(Map<String, dynamic>.from(json as Map));
  }
}
