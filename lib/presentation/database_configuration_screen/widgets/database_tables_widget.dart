import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

// lib/presentation/database_configuration_screen/widgets/database_tables_widget.dart

class DatabaseTablesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tableData;
  final VoidCallback onRefresh;

  const DatabaseTablesWidget({
    super.key,
    required this.tableData,
    required this.onRefresh,
  });

  String _getTableDescription(String tableName) {
    switch (tableName) {
      case 'user_profiles':
        return 'User profile data and preferences';
      case 'ingredients':
        return 'Nutritional information for ingredients';
      case 'orders':
        return 'Meal combinations and orders';
      case 'bmr_calculations':
        return 'Daily calorie requirements';
      default:
        return 'Database table';
    }
  }

  IconData _getTableIcon(String tableName) {
    switch (tableName) {
      case 'user_profiles':
        return Icons.person;
      case 'ingredients':
        return Icons.restaurant;
      case 'orders':
        return Icons.shopping_cart;
      case 'bmr_calculations':
        return Icons.calculate;
      default:
        return Icons.table_chart;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppTheme.successLight;
      case 'error':
        return AppTheme.errorLight;
      case 'syncing':
        return AppTheme.warningLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

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
            Row(
              children: [
                Text(
                  'Database Tables',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: onRefresh,
                  iconSize: 6.w,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            if (tableData.isEmpty)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.textSecondaryLight,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'No table data available. Check connection and try refreshing.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...tableData.map((table) => _buildTableCard(context, table)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, Map<String, dynamic> table) {
    final tableName = table['name'] as String;
    final rowCount = table['rowCount'] as int;
    final lastUpdated = table['lastUpdated'] as String;
    final status = table['status'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTableIcon(tableName),
              color: AppTheme.primaryLight,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tableName.replaceAll('_', ' ').toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  _getTableDescription(tableName),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Text(
                      'Rows: $rowCount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        'Updated: ${lastUpdated != 'Unknown' ? lastUpdated.substring(0, 10) : lastUpdated}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showTableOptions(context, tableName),
            iconSize: 5.w,
          ),
        ],
      ),
    );
  }

  void _showTableOptions(BuildContext context, String tableName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 1.w,
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              tableName.replaceAll('_', ' ').toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Schema'),
              onTap: () {
                Navigator.pop(context);
                _showSchemaDialog(context, tableName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh Data'),
              onTap: () {
                Navigator.pop(context);
                onRefresh();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showSchemaDialog(BuildContext context, String tableName) {
    Map<String, List<String>> schemas = {
      'user_profiles': [
        'id (UUID)',
        'email (TEXT)',
        'full_name (TEXT)',
        'age (INTEGER)',
        'weight (DECIMAL)',
        'height (DECIMAL)',
        'gender (ENUM)',
        'activity_level (ENUM)',
        'daily_calorie_goal (INTEGER)',
      ],
      'ingredients': [
        'id (UUID)',
        'name (TEXT)',
        'category (ENUM)',
        'calories_per_100g (DECIMAL)',
        'protein_per_100g (DECIMAL)',
        'carbs_per_100g (DECIMAL)',
        'fat_per_100g (DECIMAL)',
        'description (TEXT)',
      ],
      'orders': [
        'id (UUID)',
        'user_id (UUID)',
        'meal_category (ENUM)',
        'total_calories (DECIMAL)',
        'total_protein (DECIMAL)',
        'order_status (ENUM)',
        'order_date (TIMESTAMP)',
      ],
      'bmr_calculations': [
        'id (UUID)',
        'user_id (UUID)',
        'bmr_value (DECIMAL)',
        'tdee_value (DECIMAL)',
        'calculation_date (TIMESTAMP)',
      ],
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${tableName.replaceAll('_', ' ').toUpperCase()} Schema'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...schemas[tableName]?.map(
                    (field) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chevron_right,
                            size: 4.w,
                            color: AppTheme.textSecondaryLight,
                          ),
                          Expanded(
                            child: Text(
                              field,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) ??
                  [const Text('Schema not available')],
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
}
