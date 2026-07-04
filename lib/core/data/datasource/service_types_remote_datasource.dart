import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/service_type_model.dart';

abstract class ServiceTypesRemoteDataSource {
  Future<List<ServiceTypeModel>> getServiceTypes();
}

class ServiceTypesRemoteDataSourceImpl implements ServiceTypesRemoteDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<List<ServiceTypeModel>> getServiceTypes() async {
    final response = await _dio.get(Constants.serviceTypesUrl);
    final data = response.data;
    if (data == null) return [];
    final List list = data['data'] ?? data ?? [];
    return list
        .whereType<Map>()
        .map((e) => ServiceTypeModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
