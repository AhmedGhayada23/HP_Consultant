import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/course_model.dart';

const _studentCoursesUrl =
    'https://workspace.hbconsulting-services.com/api/student/courses';

abstract class CourseDataSource {
  Future<CourseListResult> getCourses({
    String? search,
    String? level,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int? durationMin,
    int? durationMax,
    int page,
    int perPage,
  });
}

class CourseRemoteDataSourceImpl implements CourseDataSource {
  final _dio = RemoteConnectionDio().dio;

  @override
  Future<CourseListResult> getCourses({
    String? search,
    String? level,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int? durationMin,
    int? durationMax,
    int page = 1,
    int perPage = 15,
  }) async {
    final params = <String, dynamic>{'page': page, 'per_page': perPage};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (level != null) params['level'] = level;
    if (categoryId != null) params['category_id'] = categoryId;
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (durationMin != null) params['duration_min'] = durationMin;
    if (durationMax != null) params['duration_max'] = durationMax;

    final response = await _dio.get(_studentCoursesUrl, queryParameters: params);

    final data = response.data;
    final List list = data['data'] ?? [];
    final meta = data['meta'] as Map? ?? {};

    return CourseListResult(
      courses: list.map((e) => CourseModel.fromJson(Map<String, dynamic>.from(e as Map))).toList(),
      currentPage: meta['current_page'] as int? ?? 1,
      lastPage: meta['last_page'] as int? ?? 1,
      total: meta['total'] as int? ?? 0,
    );
  }
}
