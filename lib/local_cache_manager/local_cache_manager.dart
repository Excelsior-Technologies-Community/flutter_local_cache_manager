import 'cache_item.dart';

class LocalCacheManager {
  LocalCacheManager._internal();
  static final LocalCacheManager instance =
  LocalCacheManager._internal();

  final Map<String, CacheItem<dynamic>> _memoryCache = {};

  /// ➕ Save data with expiry
  void set<T>(
      String key,
      T data, {
        Duration expiry = const Duration(minutes: 5),
      }) {
    _memoryCache[key] = CacheItem<T>(
      value: data,
      expiryTime: DateTime.now().add(expiry),
    );
  }

  /// 📥 Get cached data
  T? get<T>(String key) {
    final cacheItem = _memoryCache[key];

    if (cacheItem == null) return null;

    if (cacheItem.isExpired) {
      _memoryCache.remove(key);
      return null;
    }

    return cacheItem.value as T;
  }

  /// ❌ Remove specific cache
  void remove(String key) {
    _memoryCache.remove(key);
  }

  /// 🧹 Clear all cache
  void clear() {
    _memoryCache.clear();
  }

  /// 🔄 Force refresh (delete & re-set)
  void refresh<T>(
      String key,
      T data, {
        Duration expiry = const Duration(minutes: 5),
      }) {
    remove(key);
    set(key, data, expiry: expiry);
  }
}
