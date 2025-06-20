import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeeklyStatsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyStats;
  final double averageAdherence;

  const WeeklyStatsWidget({
    super.key,
    required this.weeklyStats,
    required this.averageAdherence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header with Average
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Weekly Adherence',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('${averageAdherence.toStringAsFixed(1)}% avg',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600))),
          ]),
          SizedBox(height: 3.h),

          // Bar Chart
          SizedBox(
              height: 20.h,
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  minY: 0,
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                          tooltipBorder: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                                '${rod.toY.toStringAsFixed(0)}%',
                                AppTheme.lightTheme.textTheme.bodySmall!
                                    .copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w600));
                          })),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 &&
                                    value.toInt() < weeklyStats.length) {
                                  return Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Text(
                                          weeklyStats[value.toInt()]["day"]
                                              as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant)));
                                }
                                return const SizedBox.shrink();
                              },
                              reservedSize: 3.h)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 25,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}%',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant));
                              },
                              reservedSize: 8.w))),
                  borderData: FlBorderData(
                      show: true,
                      border: Border(
                          bottom: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3)),
                          left: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3)))),
                  barGroups: weeklyStats.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final adherence = data["adherence"] as double;

                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: adherence,
                          color: _getBarColor(adherence),
                          width: 6.w,
                          borderRadius: BorderRadius.circular(2),
                          backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1))),
                    ]);
                  }).toList(),
                  gridData: FlGridData(
                      show: true,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                            strokeWidth: 1);
                      },
                      drawVerticalLine: false)))),
          SizedBox(height: 2.h),

          // Legend
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildLegendItem(
                'Excellent', AppTheme.lightTheme.colorScheme.primary, '90%+'),
            SizedBox(width: 4.w),
            _buildLegendItem(
                'Good', AppTheme.lightTheme.colorScheme.secondary, '80-89%'),
            SizedBox(width: 4.w),
            _buildLegendItem(
                'Needs Work', AppTheme.lightTheme.colorScheme.error, '<80%'),
          ]),
        ]));
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      SizedBox(width: 1.w),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: AppTheme.lightTheme.textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.w500)),
        Text(range,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 8.sp)),
      ]),
    ]);
  }

  Color _getBarColor(double adherence) {
    if (adherence >= 90) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (adherence >= 80) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }
}
