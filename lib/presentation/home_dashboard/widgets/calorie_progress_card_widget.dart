import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalorieProgressCardWidget extends StatelessWidget {
  final int dailyCalories;
  final int consumedCalories;
  final int remainingCalories;
  final bool isOptimalRange;
  final bool isLoading;

  const CalorieProgressCardWidget({
    super.key,
    required this.dailyCalories,
    required this.consumedCalories,
    required this.remainingCalories,
    required this.isOptimalRange,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = consumedCalories / dailyCalories;
    final Color statusColor = _getStatusColor();
    final String statusText = _getStatusText();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Calorie Progress',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Circular Progress Indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40.w,
                height: 40.w,
                child: CircularProgressIndicator(
                  value: isLoading ? null : progressPercentage.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLoading ? '--' : '${(progressPercentage * 100).toInt()}%',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    'Complete',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Consumed',
                  isLoading ? '--' : '$consumedCalories',
                  'kcal',
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  'Remaining',
                  isLoading ? '--' : '$remainingCalories',
                  'kcal',
                  remainingCalories > 0
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  'Target',
                  isLoading ? '--' : '$dailyCalories',
                  'kcal',
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 0.5.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    if (isLoading) return AppTheme.lightTheme.colorScheme.onSurfaceVariant;

    final double percentage = consumedCalories / dailyCalories;
    if (percentage >= 0.9 && percentage <= 1.1) {
      return AppTheme.lightTheme.colorScheme.primary; // Optimal range
    } else if (percentage > 1.1) {
      return AppTheme.lightTheme.colorScheme.error; // Exceeded
    } else {
      return AppTheme.lightTheme.colorScheme.secondary; // Under target
    }
  }

  String _getStatusText() {
    if (isLoading) return 'Loading...';

    final double percentage = consumedCalories / dailyCalories;
    if (percentage >= 0.9 && percentage <= 1.1) {
      return 'Optimal';
    } else if (percentage > 1.1) {
      return 'Exceeded';
    } else {
      return 'Under Target';
    }
  }
}
