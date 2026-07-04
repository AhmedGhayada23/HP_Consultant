import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/consultant_lookups_model.dart';
import 'package:dio/dio.dart';

abstract class ConsultantLookupsDataSource {
  Future<ConsultantLookupsModel> getConsultantLookups();
}

class ConsultantLookupsDataSourceImpl implements ConsultantLookupsDataSource {
  @override
  Future<ConsultantLookupsModel> getConsultantLookups() async {
    // نستخدم RemoteConnectionDio للحصول على الـ token، لكن نمرر الـ full URL
    // لأن الـ base URL للـ consultant endpoint هو /api وليس /api/v1
    final token = LocalStorage().readValue<String>(Constants.token) ?? '';

    final response = await RemoteConnectionDio().dio.get(
      Constants.consultantLookupsUrl,
      options: Options(
        headers: {
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return ConsultantLookupsModel.fromJson(response.data);
    }
    throw Exception('Failed to load lookups: ${response.statusCode}');
  }
}
