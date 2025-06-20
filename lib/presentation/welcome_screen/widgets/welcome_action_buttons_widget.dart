import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WelcomeActionButtonsWidget extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onLearnMore;

  const WelcomeActionButtonsWidget({
    super.key,
    required this.onGetStarted,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Get Started Button
        Container(
          width: double.infinity,
          height: 7.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(3.5.h),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onGetStarted,
              borderRadius: BorderRadius.circular(3.5.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'rocket_launch',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Get Started',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 3.w),
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
        ),

        SizedBox(height: 3.h),

        // Secondary Learn More Button
        Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3.h),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onLearnMore,
              borderRadius: BorderRadius.circular(3.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: Colors.white,
                      size: 4.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Learn More',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Skip Option for Returning Users
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home-dashboard');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Skip for now',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'skip_next',
                color: Colors.white.withValues(alpha: 0.7),
                size: 3.w,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
