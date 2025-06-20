import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WelcomeHeroSectionWidget extends StatelessWidget {
  const WelcomeHeroSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Logo
        Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(3.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'restaurant_menu',
                color: Colors.white,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'Balanced Meal',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Tagline
        Text(
          'Nutrition-Focused Ordering',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 4.h),

        // Main Headline
        Text(
          'Personalized Meals\nBased on Your\nCaloric Needs',
          style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 2.h),

        // Subtitle
        Text(
          'Calculate your daily calorie requirements and discover perfectly balanced meal combinations tailored just for you.',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
