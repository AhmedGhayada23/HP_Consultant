import 'package:hb/core/data/datasource/store_token_data_source.dart';

abstract class StoreTokenRepository {
  Future<void> storeToken();
}

class StoreTokenRepositoryImpl implements StoreTokenRepository {
  final StoreTokenDataSource dataSource;
  StoreTokenRepositoryImpl(this.dataSource);

  @override
  Future<void> storeToken() => dataSource.storeToken();
}
