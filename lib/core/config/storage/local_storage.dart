import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static LocalStorage? _instance;
  GetStorage? _storage;
  bool _initialized = false;

  LocalStorage._();

  factory LocalStorage() {
    return _instance ??= LocalStorage._();
  }

  Future<void> initStorage() async {
    if (_initialized && _storage != null) return;
    await GetStorage.init();
    _storage = GetStorage();
    _initialized = true;
  }

  // يضمن التهيئة قبل أي عملية (مهم في عزلة الخلفية للإشعارات)
  Future<void> _ensureInit() async {
    if (!_initialized || _storage == null) {
      await initStorage();
    }
  }

  Future<void> writeValue(String key, dynamic value) async {
    await _ensureInit();
    await _storage!.write(key, value);
  }

  T? readValue<T>(String key) {
    if (_storage == null) return null;
    return _storage!.read(key);
  }

  Future<void> removeKey(String key) async {
    await _ensureInit();
    await _storage!.remove(key);
  }
}
