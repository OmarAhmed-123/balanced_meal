import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WelcomeValuePropositionWidget extends StatelessWidget {
  const WelcomeValuePropositionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> valuePoints = [
      {
        'icon': 'calculate',
        'title': 'Smart Calorie Calculation',
        'description':
            'Advanced BMR formulas calculate your exact daily caloric needs based on your personal metrics.',
      },
      {
        'icon': 'restaurant',
        'title': 'Optimal Meal Combinations',
        'description':
            'Choose from curated ingredients across meat, vegetables, and carbs for perfect nutritional balance.',
      },
      {
        'icon': 'track_changes',
        'title': 'Real-time Tracking',
        'description':
            'Visual progress indicators show your calorie intake and remaining daily requirements instantly.',
      },
    ];

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose Balanced Meal?',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          ...valuePoints.map((point) => Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: CustomIconWidget(
                        iconName: point['icon'] as String,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            point['title'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            point['description'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
