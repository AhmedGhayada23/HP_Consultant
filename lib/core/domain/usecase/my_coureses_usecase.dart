import 'package:hb/core/data/models/my_coureses_model.dart';
import 'package:hb/core/domain/repository/my_coureses_repository.dart';

class MyCouresesUsecase {
  final MyCouresesRepository repository;

  MyCouresesUsecase(this.repository);

  Future<List<MyCouresesModel>> call() async {
    return await repository.getMyCourses();
  }
}
