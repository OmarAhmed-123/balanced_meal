import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalorieTrackerWidget extends StatelessWidget {
  final double currentCalories;
  final double dailyCalorieNeeds;
  final int selectedItemsCount;
  final bool isOrderEnabled;
  final VoidCallback onOrderPressed;

  const CalorieTrackerWidget({
    super.key,
    required this.currentCalories,
    required this.dailyCalorieNeeds,
    required this.selectedItemsCount,
    required this.isOrderEnabled,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (currentCalories / dailyCalorieNeeds) * 100;
    final remainingCalories = dailyCalorieNeeds - currentCalories;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),

          // Calorie summary
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Selection',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'restaurant',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '$selectedItemsCount items',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${currentCalories.toInt()} kcal',
                    style: AppTheme.calorieTextStyle(isLight: true),
                  ),
                  Text(
                    '${percentage.toInt()}% of goal',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getPercentageColor(percentage),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Status indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _getStatusBackgroundColor(percentage),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _getStatusIcon(percentage),
                  color: _getStatusIconColor(percentage),
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    _getStatusMessage(remainingCalories, percentage),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: _getStatusTextColor(percentage),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Order button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isOrderEnabled
                  ? () {
                      HapticFeedback.mediumImpact();
                      onOrderPressed();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isOrderEnabled
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.dividerColor,
                foregroundColor: isOrderEnabled
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                padding: EdgeInsets.symmetric(vertical: 4.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: isOrderEnabled ? 4 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart',
                    color: isOrderEnabled
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    isOrderEnabled ? 'Add to Order' : 'Adjust Selection',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isOrderEnabled
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 90 && percentage <= 110) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (percentage < 90) {
      return AppTheme.lightTheme.colorScheme.error;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  Color _getStatusBackgroundColor(double percentage) {
    if (percentage >= 90 && percentage <= 110) {
      return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
    } else {
      return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
    }
  }

  Color _getStatusIconColor(double percentage) {
    if (percentage >= 90 && percentage <= 110) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  Color _getStatusTextColor(double percentage) {
    if (percentage >= 90 && percentage <= 110) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  String _getStatusIcon(double percentage) {
    if (percentage >= 90 && percentage <= 110) {
      return 'check_circle';
    } else if (percentage < 90) {
      return 'add_circle';
    } else {
      return 'remove_circle';
    }
  }

  String _getStatusMessage(double remainingCalories, double percentage) {
    if (percentage >= 90 && percentage <= 110) {
      return 'Perfect! Your meal is within the optimal calorie range.';
    } else if (percentage < 90) {
      return 'Add ${remainingCalories.abs().toInt()} more calories to reach your goal.';
    } else {
      return 'Remove ${remainingCalories.abs().toInt()} calories to stay within range.';
    }
  }
}
