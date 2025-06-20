import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

// lib/presentation/database_configuration_screen/widgets/configuration_section_widget.dart

class ConfigurationSectionWidget extends StatelessWidget {
  final bool isApiKeyVisible;
  final VoidCallback onToggleApiKey;

  const ConfigurationSectionWidget({
    super.key,
    required this.isApiKeyVisible,
    required this.onToggleApiKey,
  });

  String _getMaskedApiKey() {
    const apiKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNhZ2VuY2hjemZpc3poemJ1ZGVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzMzMzNDYsImV4cCI6MjA2NTkwOTM0Nn0.KPdQrvHM5QM98N63yAvJdtw08RXof6jy2LZjkBppmSM';
    return isApiKeyVisible
        ? apiKey
        : '${apiKey.substring(0, 20)}${'*' * 20}${apiKey.substring(apiKey.length - 10)}';
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Database Configuration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),

            // Project URL
            _buildConfigField(
              context,
              label: 'Project URL',
              value: 'https://cagenchczfiszhzbudek.supabase.co',
              isReadOnly: true,
              onCopy: () => _copyToClipboard(context,
                  'https://cagenchczfiszhzbudek.supabase.co', 'Project URL'),
            ),

            SizedBox(height: 2.h),

            // API Key
            _buildConfigField(
              context,
              label: 'API Key (anon/public)',
              value: _getMaskedApiKey(),
              isReadOnly: true,
              isPassword: !isApiKeyVisible,
              onToggleVisibility: onToggleApiKey,
              onCopy: () => _copyToClipboard(
                  context,
                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNhZ2VuY2hjemZpc3poemJ1ZGVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzMzMzNDYsImV4cCI6MjA2NTkwOTM0Nn0.KPdQrvHM5QM98N63yAvJdtw08RXof6jy2LZjkBppmSM',
                  'API Key'),
            ),

            SizedBox(height: 2.h),

            // Security Notice
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accentLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.accentLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'This key is safe for browser use with Row Level Security (RLS) enabled.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentLight,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigField(
    BuildContext context, {
    required String label,
    required String value,
    bool isReadOnly = false,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
    VoidCallback? onCopy,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          initialValue: value,
          readOnly: isReadOnly,
          obscureText: isPassword,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onToggleVisibility != null)
                  IconButton(
                    icon: Icon(
                      isPassword ? Icons.visibility : Icons.visibility_off,
                      size: 5.w,
                    ),
                    onPressed: onToggleVisibility,
                  ),
                if (onCopy != null)
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 5.w,
                    ),
                    onPressed: onCopy,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
