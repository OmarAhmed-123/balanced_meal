import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WelcomeInfoBottomSheetWidget extends StatelessWidget {
  const WelcomeInfoBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'icon': 'science',
        'title': 'Harris-Benedict Formula',
        'description':
            'Uses scientifically proven BMR calculations for accurate calorie requirements based on gender, age, weight, and height.',
      },
      {
        'icon': 'category',
        'title': 'Three Food Categories',
        'description':
            'Select from meat, vegetables, and carbohydrates to ensure balanced macronutrient distribution in every meal.',
      },
      {
        'icon': 'tune',
        'title': 'Quantity Control',
        'description':
            'Add or remove multiple quantities of the same ingredient with real-time calorie tracking and visual feedback.',
      },
      {
        'icon': 'target',
        'title': '10% Optimal Range',
        'description':
            'Order button activates when your meal selection is within 10% of your calculated daily caloric needs.',
      },
      {
        'icon': 'cloud',
        'title': 'Firebase Integration',
        'description':
            'Fresh ingredient data retrieved from cloud database with high-quality images and nutritional information.',
      },
      {
        'icon': 'api',
        'title': 'Seamless Ordering',
        'description':
            'Direct API integration for order placement with automatic navigation reset after successful submission.',
      },
    ];

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.w),
          topRight: Radius.circular(6.w),
        ),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            width: 12.w,
            height: 1.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(0.5.h),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Features',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Everything you need for personalized nutrition',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.textTheme.bodyLarge?.color ??
                        Colors.black,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // Features List
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              itemCount: features.length,
              separatorBuilder: (context, index) => SizedBox(height: 3.h),
              itemBuilder: (context, index) {
                final feature = features[index];
                return Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(3.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: CustomIconWidget(
                          iconName: feature['icon'] as String,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature['title'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              feature['description'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                height: 1.4,
                                color: AppTheme
                                    .lightTheme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Action
          Padding(
            padding: EdgeInsets.all(6.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/user-profile-setup');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start Your Journey',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
