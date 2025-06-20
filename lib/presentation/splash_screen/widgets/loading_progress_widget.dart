import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoadingProgressWidget extends StatelessWidget {
  final Animation<double> animation;
  final String loadingText;
  final bool hasError;
  final bool isInitialized;

  const LoadingProgressWidget({
    super.key,
    required this.animation,
    required this.loadingText,
    required this.hasError,
    required this.isInitialized,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress Indicator
        Container(
          width: 60.w,
          height: 0.8.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    width: (60.w) * animation.value,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: hasError
                          ? AppTheme.errorLight
                          : isInitialized
                              ? AppTheme.successLight
                              : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: (hasError
                                  ? AppTheme.errorLight
                                  : isInitialized
                                      ? AppTheme.successLight
                                      : Colors.white)
                              .withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        SizedBox(height: 3.h),

        // Loading Text with Status Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasError)
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.errorLight,
                size: 18,
              )
            else if (isInitialized)
              CustomIconWidget(
                iconName: 'check_circle_outline',
                color: AppTheme.successLight,
                size: 18,
              )
            else
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            SizedBox(width: 2.w),
            Text(
              loadingText,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Progress Percentage
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Text(
              '${(animation.value * 100).toInt()}%',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
      ],
    );
  }
}
