# 🗄️ Local Cache Manager (Expiry Based)

A lightweight, dependency-free **Expiry-Based Local Cache Manager** for Flutter.

This utility allows you to store data locally in memory with a defined **expiry time**, ensuring fast access while automatically invalidating stale data.

Perfect for:

* API response caching
* Home screen data
* Product lists
* Feature flags
* App configuration

---

## ✨ Features

* ⏳ Expiry-based caching
* ⚡ Fast in-memory access
* 🧠 Automatic cache invalidation
* 🧩 Generic type support (`<T>`)
* 🧹 Clear / remove cache easily
* 📦 No third-party dependencies
* 🚀 Library-ready clean architecture

---
## ✨ Preview





https://github.com/user-attachments/assets/7712121e-ccff-40a3-8588-97ea02a2be03


---

## 📦 Folder Structure

```
lib/
 ├── local_cache/
 │    ├── cache_item.dart
 │    ├── local_cache_manager.dart
 │    └── cache_keys.dart
 │
 └── demo/
      └── local_cache_demo_screen.dart
```

---

## 🧠 How It Works

1. Data is stored with an **expiry time**
2. When fetching data:

   * If cache exists and is not expired → return cached data
   * If cache is expired → delete it and return `null`
3. App decides whether to call API again

---

## 🧩 Core Classes

### CacheItem

Stores cached data along with expiry time.

```dart
class CacheItem<T> {
  final T value;
  final DateTime expiryTime;

  CacheItem({
    required this.value,
    required this.expiryTime,
  });

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}
```

---

### LocalCacheManager

Handles all cache operations.

```dart
class LocalCacheManager {
  LocalCacheManager._internal();
  static final LocalCacheManager instance = LocalCacheManager._internal();

  final Map<String, CacheItem<dynamic>> _memoryCache = {};

  void set<T>(String key, T data, {Duration expiry = const Duration(minutes: 5)}) {
    _memoryCache[key] = CacheItem<T>(
      value: data,
      expiryTime: DateTime.now().add(expiry),
    );
  }

  T? get<T>(String key) {
    final cacheItem = _memoryCache[key];

    if (cacheItem == null) return null;

    if (cacheItem.isExpired) {
      _memoryCache.remove(key);
      return null;
    }

    return cacheItem.value as T;
  }

  void remove(String key) {
    _memoryCache.remove(key);
  }

  void clear() {
    _memoryCache.clear();
  }
}
```

---

## 🔑 Cache Keys (Best Practice)

```dart
class CacheKeys {
  static const users = 'users_cache';
  static const products = 'products_cache';
  static const profile = 'profile_cache';
}
```

---

## 🚀 Usage Example

### Save Data to Cache

```dart
LocalCacheManager.instance.set(
  CacheKeys.users,
  usersList,
  expiry: Duration(minutes: 10),
);
```

### Get Cached Data

```dart
final cachedUsers = LocalCacheManager.instance
    .get<List<User>>(CacheKeys.users);

if (cachedUsers != null) {
  print('Loaded from cache');
} else {
  print('Cache expired or not found');
}
```

---

## 🌐 API Integration Example

```dart
Future<List<String>> fetchUsers() async {
  final cache = LocalCacheManager.instance;

  final cached = cache.get<List<String>>(CacheKeys.users);
  if (cached != null) return cached;

  final apiData = await apiCall();

  cache.set(
    CacheKeys.users,
    apiData,
    expiry: Duration(minutes: 5),
  );

  return apiData;
}
```

---

## 📱 Demo Screen

The demo screen demonstrates:

* Cache read/write
* Expiry behavior
* Manual cache clear
* API vs Cache state

File:

```
lib/demo/local_cache_demo_screen.dart
```

---

## ⚠️ Limitations

* In-memory cache only (cleared on app restart)
* Not suitable for large or persistent data
* Not recommended for sensitive data

---

## 🔜 Future Enhancements

* 💾 Persistent cache (SharedPreferences / Hive)
* ⏱ Auto cleanup timer
* 📊 Cache size limit
* 🔐 Secure storage support
* 🧪 Unit tests
* 📦 Publish as Flutter package

---

## 📌 Use Case Summary

This Expiry-Based Local Cache Manager is ideal when you need:

* Faster app performance
* Reduced API calls
* Controlled data freshness
* Simple and reusable cache solution

---

## 🧑‍💻 Author

Built with ❤️ for Flutter developers who love clean architecture.

---

## 📄 License

MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.
```
