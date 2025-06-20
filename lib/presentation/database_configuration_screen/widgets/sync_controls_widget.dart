import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

// lib/presentation/database_configuration_screen/widgets/sync_controls_widget.dart

class SyncControlsWidget extends StatelessWidget {
  final bool isRealTimeEnabled;
  final VoidCallback onToggleRealTime;

  const SyncControlsWidget({
    super.key,
    required this.isRealTimeEnabled,
    required this.onToggleRealTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Synchronization Controls',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),

            // Real-time Sync Toggle
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.dividerLight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sync,
                    color: isRealTimeEnabled
                        ? AppTheme.successLight
                        : AppTheme.textSecondaryLight,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Real-time Synchronization',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Automatically sync data changes across all connected devices',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isRealTimeEnabled,
                    onChanged: (value) => onToggleRealTime(),
                    activeColor: AppTheme.successLight,
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Sync Status Indicator
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isRealTimeEnabled
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isRealTimeEnabled
                      ? AppTheme.successLight.withValues(alpha: 0.3)
                      : AppTheme.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isRealTimeEnabled ? Icons.check_circle : Icons.warning,
                    color: isRealTimeEnabled
                        ? AppTheme.successLight
                        : AppTheme.warningLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      isRealTimeEnabled
                          ? 'Real-time sync is active. Data changes will be reflected immediately.'
                          : 'Real-time sync is disabled. Manual refresh required for updates.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isRealTimeEnabled
                                ? AppTheme.successLight
                                : AppTheme.warningLight,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Additional Sync Options
            Text(
              'Sync Options',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 1.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showMigrationDialog(context),
                    icon: Icon(
                      Icons.upload,
                      size: 5.w,
                    ),
                    label: const Text('Deploy Schema'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showRollbackDialog(context),
                    icon: Icon(
                      Icons.history,
                      size: 5.w,
                    ),
                    label: const Text('Rollback'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMigrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deploy Database Schema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will deploy the latest database schema changes to the production environment.',
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: AppTheme.warningLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  const Expanded(
                    child: Text(
                      'This action cannot be undone. Make sure you have a backup.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performMigration(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningLight,
            ),
            child: const Text('Deploy'),
          ),
        ],
      ),
    );
  }

  void _showRollbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rollback Database'),
        content: const Text(
          'This will rollback the database to the previous migration. All recent changes will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performRollback(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Rollback'),
          ),
        ],
      ),
    );
  }

  void _performMigration(BuildContext context) {
    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppTheme.primaryLight),
            SizedBox(height: 2.h),
            const Text('Deploying schema changes...'),
          ],
        ),
      ),
    );

    // Simulate migration process
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schema deployment completed successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    });
  }

  void _performRollback(BuildContext context) {
    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppTheme.errorLight),
            SizedBox(height: 2.h),
            const Text('Rolling back database...'),
          ],
        ),
      ),
    );

    // Simulate rollback process
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database rollback completed'),
          backgroundColor: AppTheme.warningLight,
        ),
      );
    });
  }
}
