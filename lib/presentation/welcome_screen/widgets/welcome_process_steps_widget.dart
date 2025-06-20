import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WelcomeProcessStepsWidget extends StatelessWidget {
  const WelcomeProcessStepsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> processSteps = [
      {
        'step': '01',
        'icon': 'person',
        'title': 'Profile Input',
        'description':
            'Enter your gender, weight, height, and age for personalized calculations.',
      },
      {
        'step': '02',
        'icon': 'analytics',
        'title': 'Calorie Calculation',
        'description':
            'Our system calculates your daily caloric needs using proven BMR formulas.',
      },
      {
        'step': '03',
        'icon': 'shopping_cart',
        'title': 'Ingredient Selection',
        'description':
            'Choose from three categories to build your perfect balanced meal.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How It Works',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Three simple steps to your perfect meal',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: 4.h),
        ...processSteps.asMap().entries.map((entry) {
          final int index = entry.key;
          final Map<String, dynamic> step = entry.value;
          final bool isLast = index == processSteps.length - 1;

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Number and Line
                  Column(
                    children: [
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.lightTheme.colorScheme.primary,
                              AppTheme.lightTheme.colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8.w),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: step['icon'] as String,
                              color: Colors.white,
                              size: 6.w,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              step['step'] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 6.h,
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(width: 4.w),

                  // Step Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'] as String,
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            step['description'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (!isLast) SizedBox(height: 2.h),
            ],
          );
        }),
      ],
    );
  }
}
