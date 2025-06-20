import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

// lib/presentation/database_configuration_screen/widgets/connection_status_card_widget.dart

class ConnectionStatusCardWidget extends StatelessWidget {
  final bool isConnected;
  final String lastSyncTime;
  final VoidCallback onRefresh;
  final String? connectionError;

  const ConnectionStatusCardWidget({
    super.key,
    required this.isConnected,
    required this.lastSyncTime,
    required this.onRefresh,
    this.connectionError,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isConnected
                            ? AppTheme.successLight
                            : AppTheme.errorLight)),
                SizedBox(width: 3.w),
                Text('Connection Status',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: onRefresh,
                    iconSize: 6.w),
              ]),
              SizedBox(height: 2.h),
              Row(children: [
                Text('Status: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppTheme.textSecondaryLight)),
                Text(isConnected ? 'Connected' : 'Disconnected',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isConnected
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                        fontWeight: FontWeight.w500)),
              ]),
              SizedBox(height: 1.h),
              Row(children: [
                Text('Last Sync: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppTheme.textSecondaryLight)),
                Expanded(
                    child: Text(lastSyncTime,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis)),
              ]),
              if (connectionError != null) ...[
                SizedBox(height: 2.h),
                Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        color: AppTheme.errorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.errorLight.withValues(alpha: 0.3))),
                    child: Row(children: [
                      Icon(Icons.error_outline,
                          color: AppTheme.errorLight, size: 5.w),
                      SizedBox(width: 2.w),
                      Expanded(
                          child: Text(connectionError!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.errorLight))),
                    ])),
              ],
            ])));
  }
}
