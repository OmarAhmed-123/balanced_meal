import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeightInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String selectedUnit;
  final Function(String) onUnitChanged;
  final Function(String) onChanged;

  const WeightInputWidget({
    super.key,
    required this.controller,
    required this.selectedUnit,
    required this.onUnitChanged,
    required this.onChanged,
  });

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }

    if (selectedUnit == 'kg') {
      if (weight < 30 || weight > 300) {
        return 'Weight must be between 30-300 kg';
      }
    } else {
      if (weight < 66 || weight > 660) {
        return 'Weight must be between 66-660 lbs';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: _validateWeight,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: selectedUnit == 'kg'
                      ? 'Enter weight in kg'
                      : 'Enter weight in lbs',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'monitor_weight',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              flex: 1,
              child: Container(
                height: 7.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onUnitChanged('kg'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedUnit == 'kg'
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3.w),
                              bottomLeft: Radius.circular(3.w),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'kg',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: selectedUnit == 'kg'
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: selectedUnit == 'kg'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onUnitChanged('lbs'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedUnit == 'lbs'
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(3.w),
                              bottomRight: Radius.circular(3.w),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'lbs',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: selectedUnit == 'lbs'
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: selectedUnit == 'lbs'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
