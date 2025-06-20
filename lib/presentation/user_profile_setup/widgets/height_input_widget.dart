import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeightInputWidget extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController feetController;
  final TextEditingController inchesController;
  final String selectedUnit;
  final Function(String) onUnitChanged;
  final Function(String) onChanged;

  const HeightInputWidget({
    super.key,
    required this.heightController,
    required this.feetController,
    required this.inchesController,
    required this.selectedUnit,
    required this.onUnitChanged,
    required this.onChanged,
  });

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    }

    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid number';
    }

    if (height < 100 || height > 250) {
      return 'Height must be between 100-250 cm';
    }

    return null;
  }

  String? _validateFeet(String? value) {
    if (value == null || value.isEmpty) {
      return 'Feet is required';
    }

    final feet = int.tryParse(value);
    if (feet == null) {
      return 'Please enter a valid number';
    }

    if (feet < 3 || feet > 8) {
      return 'Feet must be between 3-8';
    }

    return null;
  }

  String? _validateInches(String? value) {
    if (value == null || value.isEmpty) {
      return 'Inches is required';
    }

    final inches = int.tryParse(value);
    if (inches == null) {
      return 'Please enter a valid number';
    }

    if (inches < 0 || inches > 11) {
      return 'Inches must be between 0-11';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.5.h),

        // Unit selector
        Container(
          width: double.infinity,
          height: 6.h,
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
                  onTap: () => onUnitChanged('cm'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedUnit == 'cm'
                          ? AppTheme.lightTheme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.w),
                        bottomLeft: Radius.circular(3.w),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'cm',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: selectedUnit == 'cm'
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: selectedUnit == 'cm'
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
                  onTap: () => onUnitChanged('ft'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedUnit == 'ft'
                          ? AppTheme.lightTheme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(3.w),
                        bottomRight: Radius.circular(3.w),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'ft/in',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: selectedUnit == 'ft'
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: selectedUnit == 'ft'
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
        SizedBox(height: 2.h),

        // Input fields
        selectedUnit == 'cm'
            ? TextFormField(
                controller: heightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: _validateHeight,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Enter height in cm',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'height',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  suffixText: 'cm',
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: feetController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: _validateFeet,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: 'Feet',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'height',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                        suffixText: 'ft',
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: TextFormField(
                      controller: inchesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: _validateInches,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: 'Inches',
                        suffixText: 'in',
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
