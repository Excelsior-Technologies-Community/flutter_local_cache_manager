import 'package:flutter/material.dart';
import 'package:flutter_local_cache_manager/local_cache_manager/cache_keys.dart';
import 'package:flutter_local_cache_manager/local_cache_manager/local_cache_manager.dart';

class LocalCacheDemoScreen extends StatefulWidget {
  const LocalCacheDemoScreen({Key? key}) : super(key: key);

  @override
  State<LocalCacheDemoScreen> createState() =>
      _LocalCacheDemoScreenState();
}

class _LocalCacheDemoScreenState
    extends State<LocalCacheDemoScreen> {
  String _status = 'Press button to fetch data';
  List<String> _data = [];

  /// 🔥 Simulated API Call
  Future<List<String>> _fakeApiCall() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      'Apple',
      'Banana',
      'Mango',
      'Orange',
    ];
  }

  /// 📦 Fetch Data (Cache → API)
  Future<void> fetchData() async {
    final cache = LocalCacheManager.instance;

    final cached =
    cache.get<List<String>>(CacheKeys.products);

    if (cached != null) {
      setState(() {
        _data = cached;
        _status = '✅ Loaded from CACHE';
      });
      return;
    }

    setState(() {
      _status = '⏳ Fetching from API...';
    });

    final apiData = await _fakeApiCall();

    cache.set(
      CacheKeys.products,
      apiData,
      expiry: const Duration(seconds: 10),
    );

    setState(() {
      _data = apiData;
      _status = '🌐 Loaded from API (Cached for 10s)';
    });
  }

  /// ❌ Clear Cache
  void clearCache() {
    LocalCacheManager.instance.remove(CacheKeys.products);
    setState(() {
      _data.clear();
      _status = '🧹 Cache Cleared';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Cache Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: fetchData,
                    child: const Text('Fetch Data'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: clearCache,
                    child: const Text('Clear Cache'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Data:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Data List
            Expanded(
              child: _data.isEmpty
                  ? const Center(
                child: Text(
                  'No data',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.storage),
                      title: Text(_data[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
