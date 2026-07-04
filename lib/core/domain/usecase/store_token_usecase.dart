import 'package:hb/core/domain/repository/store_token_repository.dart';

class StoreTokenUsecase {
  final StoreTokenRepository repository;
  StoreTokenUsecase(this.repository);

  Future<void> call() => repository.storeToken();
}
