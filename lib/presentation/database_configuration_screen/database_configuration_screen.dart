import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import './widgets/configuration_section_widget.dart';
import './widgets/connection_status_card_widget.dart';
import './widgets/database_tables_widget.dart';
import './widgets/export_functionality_widget.dart';
import './widgets/sync_controls_widget.dart';

// lib/presentation/database_configuration_screen/database_configuration_screen.dart

class DatabaseConfigurationScreen extends StatefulWidget {
  const DatabaseConfigurationScreen({super.key});

  @override
  State<DatabaseConfigurationScreen> createState() =>
      _DatabaseConfigurationScreenState();
}

class _DatabaseConfigurationScreenState
    extends State<DatabaseConfigurationScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = true;
  bool _isConnected = false;
  bool _isApiKeyVisible = false;
  bool _isRealTimeEnabled = false;
  String _lastSyncTime = 'Never';
  List<Map<String, dynamic>> _tableData = [];
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() {
      _isLoading = true;
      _connectionError = null;
    });

    try {
      // Check connection status
      _isConnected = await _supabaseService.checkConnection();

      if (_isConnected) {
        await _loadTableData();
        _lastSyncTime = DateTime.now().toString().substring(0, 19);
      }
    } catch (e) {
      _connectionError = e.toString();
      _isConnected = false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTableData() async {
    try {
      final tables = [
        'user_profiles',
        'ingredients',
        'orders',
        'bmr_calculations'
      ];
      final List<Map<String, dynamic>> tableInfo = [];

      for (final table in tables) {
        final info = await _supabaseService.getTableInfo(table);
        tableInfo.add(info);
      }

      setState(() {
        _tableData = tableInfo;
      });
    } catch (e) {
      debugPrint('Error loading table data: $e');
    }
  }

  Future<void> _refreshConnection() async {
    await _initializeScreen();
  }

  Future<void> _toggleRealTimeSync() async {
    setState(() {
      _isRealTimeEnabled = !_isRealTimeEnabled;
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isRealTimeEnabled
            ? 'Real-time sync enabled'
            : 'Real-time sync disabled'),
        backgroundColor:
            _isRealTimeEnabled ? AppTheme.successLight : AppTheme.warningLight,
      ),
    );
  }

  Future<void> _refreshTableData() async {
    if (_isConnected) {
      await _loadTableData();
      setState(() {
        _lastSyncTime = DateTime.now().toString().substring(0, 19);
      });
    }
  }

  void _toggleApiKeyVisibility() {
    setState(() {
      _isApiKeyVisible = !_isApiKeyVisible;
    });
  }

  Future<void> _exportData() async {
    try {
      final tables = [
        'user_profiles',
        'ingredients',
        'orders',
        'bmr_calculations'
      ];
      final Map<String, dynamic> exportData = {};

      for (final table in tables) {
        final data = await _supabaseService.exportTableData(table);
        exportData[table] = data;
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data export completed successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Database Settings',
          style: AppTheme.lightTheme.textTheme.headlineSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshConnection,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryLight),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection Status Card
                  ConnectionStatusCardWidget(
                    isConnected: _isConnected,
                    lastSyncTime: _lastSyncTime,
                    onRefresh: _refreshConnection,
                    connectionError: _connectionError,
                  ),

                  SizedBox(height: 3.h),

                  // Configuration Section
                  ConfigurationSectionWidget(
                    isApiKeyVisible: _isApiKeyVisible,
                    onToggleApiKey: _toggleApiKeyVisibility,
                  ),

                  SizedBox(height: 3.h),

                  // Database Tables
                  DatabaseTablesWidget(
                    tableData: _tableData,
                    onRefresh: _refreshTableData,
                  ),

                  SizedBox(height: 3.h),

                  // Sync Controls
                  SyncControlsWidget(
                    isRealTimeEnabled: _isRealTimeEnabled,
                    onToggleRealTime: _toggleRealTimeSync,
                  ),

                  SizedBox(height: 3.h),

                  // Export Functionality
                  ExportFunctionalityWidget(
                    onExport: _exportData,
                  ),

                  SizedBox(height: 5.h),
                ],
              ),
            ),
    );
  }
}