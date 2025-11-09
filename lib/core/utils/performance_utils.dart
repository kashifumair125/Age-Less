import 'dart:async';
import 'package:flutter/foundation.dart';

/// Performance optimization utilities
class PerformanceUtils {
  /// Debounce function calls
  static Timer? _debounceTimer;

  static void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }

  /// Throttle function calls
  static Timer? _throttleTimer;
  static bool _isThrottling = false;

  static void throttle(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (_isThrottling) return;

    _isThrottling = true;
    callback();

    _throttleTimer = Timer(duration, () {
      _isThrottling = false;
    });
  }

  /// Cancel pending debounce/throttle timers
  static void cancelTimers() {
    _debounceTimer?.cancel();
    _throttleTimer?.cancel();
    _isThrottling = false;
  }

  /// Measure execution time of a function
  static Future<T> measureAsync<T>(
    String label,
    Future<T> Function() function,
  ) async {
    if (!kDebugMode) {
      return await function();
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = await function();
      stopwatch.stop();
      debugPrint('⏱️ $label took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint('⏱️ $label failed after ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }

  /// Measure execution time of a synchronous function
  static T measure<T>(
    String label,
    T Function() function,
  ) {
    if (!kDebugMode) {
      return function();
    }

    final stopwatch = Stopwatch()..start();
    try {
      final result = function();
      stopwatch.stop();
      debugPrint('⏱️ $label took ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint('⏱️ $label failed after ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }
}

/// Lazy loader for paginated lists
class LazyListLoader<T> {
  final Future<List<T>> Function(int page, int pageSize) fetchPage;
  final int pageSize;

  final List<T> _items = [];
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoading = false;

  LazyListLoader({
    required this.fetchPage,
    this.pageSize = 20,
  });

  List<T> get items => List.unmodifiable(_items);
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  /// Load the next page of items
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    try {
      final newItems = await fetchPage(_currentPage, pageSize);

      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _items.addAll(newItems);
        _currentPage++;
        _hasMore = newItems.length == pageSize;
      }
    } finally {
      _isLoading = false;
    }
  }

  /// Refresh the list (load from beginning)
  Future<void> refresh() async {
    _items.clear();
    _currentPage = 0;
    _hasMore = true;
    await loadMore();
  }

  /// Clear all items
  void clear() {
    _items.clear();
    _currentPage = 0;
    _hasMore = true;
  }
}

/// Simple in-memory cache
class MemoryCache<K, V> {
  final Map<K, _CacheEntry<V>> _cache = {};
  final Duration ttl;
  final int maxSize;

  MemoryCache({
    this.ttl = const Duration(minutes: 5),
    this.maxSize = 100,
  });

  /// Get value from cache
  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry.value;
  }

  /// Put value in cache
  void put(K key, V value) {
    // Remove oldest entry if cache is full
    if (_cache.length >= maxSize) {
      final oldestKey = _cache.entries
          .reduce((a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
          .key;
      _cache.remove(oldestKey);
    }

    _cache[key] = _CacheEntry(value, ttl);
  }

  /// Check if key exists and is not expired
  bool contains(K key) {
    return get(key) != null;
  }

  /// Remove specific key
  void remove(K key) {
    _cache.remove(key);
  }

  /// Clear entire cache
  void clear() {
    _cache.clear();
  }

  /// Remove all expired entries
  void cleanExpired() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }

  /// Get cache size
  int get size => _cache.length;
}

class _CacheEntry<V> {
  final V value;
  final DateTime timestamp;
  final Duration ttl;

  _CacheEntry(this.value, this.ttl) : timestamp = DateTime.now();

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}

/// Batch processor for database operations
class BatchProcessor<T> {
  final Future<void> Function(List<T>) processBatch;
  final Duration batchWindow;
  final int maxBatchSize;

  final List<T> _buffer = [];
  Timer? _timer;
  bool _isProcessing = false;

  BatchProcessor({
    required this.processBatch,
    this.batchWindow = const Duration(milliseconds: 500),
    this.maxBatchSize = 50,
  });

  /// Add item to batch
  Future<void> add(T item) async {
    _buffer.add(item);

    // Process immediately if batch is full
    if (_buffer.length >= maxBatchSize) {
      _timer?.cancel();
      await _processBatch();
    } else {
      // Reset timer
      _timer?.cancel();
      _timer = Timer(batchWindow, _processBatch);
    }
  }

  /// Process all pending items
  Future<void> flush() async {
    _timer?.cancel();
    await _processBatch();
  }

  Future<void> _processBatch() async {
    if (_buffer.isEmpty || _isProcessing) return;

    _isProcessing = true;
    try {
      final itemsToProcess = List<T>.from(_buffer);
      _buffer.clear();
      await processBatch(itemsToProcess);
    } finally {
      _isProcessing = false;
    }
  }

  /// Dispose resources
  void dispose() {
    _timer?.cancel();
  }
}

/// Image cache key generator
class ImageCacheUtils {
  /// Generate cache key for image URL
  static String generateCacheKey(String url, {int? width, int? height}) {
    final buffer = StringBuffer(url);
    if (width != null) buffer.write('_w$width');
    if (height != null) buffer.write('_h$height');
    return buffer.toString();
  }

  /// Get thumbnail size based on screen size
  static int getThumbnailSize(double screenWidth) {
    if (screenWidth < 400) return 200;
    if (screenWidth < 600) return 300;
    return 400;
  }
}
