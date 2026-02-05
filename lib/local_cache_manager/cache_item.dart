/// Holds cached data with expiry time
class CacheItem<T> {
  final T value;
  final DateTime expiryTime;

  CacheItem({
    required this.value,
    required this.expiryTime,
  });

  /// Check if cache is expired
  bool get isExpired => DateTime.now().isAfter(expiryTime);
}
