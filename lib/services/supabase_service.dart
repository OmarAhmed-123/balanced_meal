// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;
  final Future<void> _initFuture;

  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal() : _initFuture = _initializeSupabase();

  // Internal initialization logic
  static Future<void> _initializeSupabase() async {
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://cagenchczfiszhzbudek.supabase.co',
    );
    const supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNhZ2VuY2hjemZpc3poemJ1ZGVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzMzMzNDYsImV4cCI6MjA2NTkwOTM0Nn0.KPdQrvHM5QM98N63yAvJdtw08RXof6jy2LZjkBppmSM',
    );

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be defined using --dart-define.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _instance._client = Supabase.instance.client;
    _instance._isInitialized = true;
  }

  // Client getter (async)
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await _initFuture;
    }
    return _client;
  }

  // Connection status check
  Future<bool> checkConnection() async {
    try {
      final client = await this.client;
      final response =
          await client.from('user_profiles').select('count').limit(1);
      return response != null;
    } catch (e) {
      debugPrint('Supabase connection failed: $e');
      return false;
    }
  }

  // Get table information
  Future<Map<String, dynamic>> getTableInfo(String tableName) async {
    try {
      final client = await this.client;
      final response = await client.from(tableName).select('*').limit(1);

      // Get row count
      final countResponse = await client
          .from(tableName)
          .select('*', count: CountOption.exact)
          .limit(1);

      return {
        'name': tableName,
        'rowCount': countResponse.count,
        'lastUpdated': DateTime.now().toIso8601String(),
        'status': 'active',
      };
    } catch (e) {
      debugPrint('Error getting table info for $tableName: $e');
      return {
        'name': tableName,
        'rowCount': 0,
        'lastUpdated': 'Unknown',
        'status': 'error',
      };
    }
  }

  // Sync status check
  Future<bool> checkSyncStatus() async {
    try {
      final client = await this.client;

      // Check if we can query multiple tables
      final futures = [
        client.from('user_profiles').select('count').limit(1),
        client.from('ingredients').select('count').limit(1),
        client.from('orders').select('count').limit(1),
        client.from('bmr_calculations').select('count').limit(1),
      ];

      await Future.wait(futures);
      return true;
    } catch (e) {
      debugPrint('Sync status check failed: $e');
      return false;
    }
  }

  // Export data functionality
  Future<Map<String, dynamic>> exportTableData(String tableName) async {
    try {
      final client = await this.client;
      final response = await client.from(tableName).select('*');

      return {
        'tableName': tableName,
        'data': response,
        'exportDate': DateTime.now().toIso8601String(),
        'recordCount': response.length,
      };
    } catch (e) {
      debugPrint('Error exporting data from $tableName: $e');
      throw Exception('Failed to export data from $tableName: $e');
    }
  }
}