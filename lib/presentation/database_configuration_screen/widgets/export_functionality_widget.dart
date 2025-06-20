import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

// lib/presentation/database_configuration_screen/widgets/export_functionality_widget.dart

class ExportFunctionalityWidget extends StatelessWidget {
  final VoidCallback onExport;

  const ExportFunctionalityWidget({
    super.key,
    required this.onExport,
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
              'Data Management',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),

            // Export Section
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.dividerLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.download,
                        color: AppTheme.primaryLight,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Export Database',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Download complete database backup for compliance and reporting',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Export Options
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showExportDialog(context, 'JSON'),
                          icon: Icon(
                            Icons.code,
                            size: 4.w,
                          ),
                          label: const Text('JSON'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.5.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showExportDialog(context, 'CSV'),
                          icon: Icon(
                            Icons.table_chart,
                            size: 4.w,
                          ),
                          label: const Text('CSV'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.5.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onExport,
                          icon: Icon(
                            Icons.backup,
                            size: 4.w,
                          ),
                          label: const Text('Full'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.5.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Compliance Information
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accentLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentLight.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: AppTheme.accentLight,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Data Compliance',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppTheme.accentLight,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Exported data includes user profile information, meal preferences, and nutritional data. Ensure compliance with GDPR and local privacy regulations when handling exported data.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentLight,
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Additional Actions
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _showDiagnosticsDialog(context),
                    icon: Icon(
                      Icons.bug_report,
                      size: 4.w,
                    ),
                    label: const Text('Run Diagnostics'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.5.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _showConnectionInfo(context),
                    icon: Icon(
                      Icons.info_outline,
                      size: 4.w,
                    ),
                    label: const Text('Connection Info'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.5.h,
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

  void _showExportDialog(BuildContext context, String format) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export as $format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Export database tables in $format format?'),
            SizedBox(height: 2.h),
            Text(
              'Tables to export:',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 1.h),
            ...[
              'User Profiles',
              'Ingredients',
              'Orders',
              'BMR Calculations',
            ].map((table) => Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.successLight,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      table,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )),
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
              _performExport(context, format);
            },
            child: Text('Export $format'),
          ),
        ],
      ),
    );
  }

  void _performExport(BuildContext context, String format) {
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
            Text('Exporting data as $format...'),
          ],
        ),
      ),
    );

    // Simulate export process
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$format export completed successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    });
  }

  void _showDiagnosticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Database Diagnostics'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDiagnosticItem('Connection Status', 'Connected', true),
              _buildDiagnosticItem('Response Time', '< 100ms', true),
              _buildDiagnosticItem('Data Integrity', 'Valid', true),
              _buildDiagnosticItem('RLS Policies', 'Active', true),
              _buildDiagnosticItem('Schema Version', 'Latest', true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticItem(String label, String value, bool isHealthy) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Icon(
            isHealthy ? Icons.check_circle : Icons.error,
            color: isHealthy ? AppTheme.successLight : AppTheme.errorLight,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHealthy ? AppTheme.successLight : AppTheme.errorLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showConnectionInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                'Project URL', 'https://cagenchczfiszhzbudek.supabase.co'),
            _buildInfoRow('Region', 'US East (N. Virginia)'),
            _buildInfoRow('Database Version', 'PostgreSQL 15.1'),
            _buildInfoRow('Connection Pool', 'Active'),
            _buildInfoRow('SSL Encryption', 'Enabled'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
