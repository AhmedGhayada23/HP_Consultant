// lib/featuer/my_coureses/domain/repositories/courses_repository.dart
import 'package:hb/core/data/datasource/my_coureses_data_source.dart';
import 'package:hb/core/data/models/my_coureses_model.dart';


abstract class MyCouresesRepository {
  Future<List<MyCouresesModel>> getMyCourses();
}

class MyCouresesRepositoryImpl extends MyCouresesRepository {
  final MyCouresesDataSource remoteDataSource;

  MyCouresesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MyCouresesModel>> getMyCourses() async {
    return await remoteDataSource.getMyCourses();
  }
}
