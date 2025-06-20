import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/age_input_widget.dart';
import './widgets/gender_selection_widget.dart';
import './widgets/height_input_widget.dart';
import './widgets/weight_input_widget.dart';

class UserProfileSetup extends StatefulWidget {
  const UserProfileSetup({super.key});

  @override
  State<UserProfileSetup> createState() => _UserProfileSetupState();
}

class _UserProfileSetupState extends State<UserProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _feetController = TextEditingController();
  final _inchesController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedGender = '';
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  bool _isLoading = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _selectedGender.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        (_heightUnit == 'cm'
            ? _heightController.text.isNotEmpty
            : (_feetController.text.isNotEmpty &&
                _inchesController.text.isNotEmpty)) &&
        _ageController.text.isNotEmpty &&
        _formKey.currentState?.validate() == true;
  }

  double _calculateBMR() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final age = double.tryParse(_ageController.text) ?? 0;

    double height = 0;
    if (_heightUnit == 'cm') {
      height = double.tryParse(_heightController.text) ?? 0;
    } else {
      final feet = double.tryParse(_feetController.text) ?? 0;
      final inches = double.tryParse(_inchesController.text) ?? 0;
      height = (feet * 30.48) + (inches * 2.54);
    }

    double weightInKg = _weightUnit == 'kg' ? weight : weight * 0.453592;

    // Harris-Benedict equations
    if (_selectedGender == 'Male') {
      return 88.362 + (13.397 * weightInKg) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weightInKg) + (3.098 * height) - (4.330 * age);
    }
  }

  void _handleContinue() async {
    if (!_isFormValid()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate processing time
    await Future.delayed(const Duration(milliseconds: 800));

    final bmr = _calculateBMR();
    final dailyCalories = (bmr * 1.2).round(); // Sedentary activity level

    if (mounted) {
      Navigator.pushNamed(context, '/home-dashboard');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // Progress indicator
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            child: CustomIconWidget(
                              iconName: 'arrow_back',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 6.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Your Profile',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          'Step 1 of 4',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          '25%',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: 0.25,
                      backgroundColor: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.h),

                        Text(
                          'Tell us about yourself',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'We need this information to calculate your daily calorie needs accurately.',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 4.h),

                        // Gender Selection
                        GenderSelectionWidget(
                          selectedGender: _selectedGender,
                          onGenderChanged: (gender) {
                            setState(() {
                              _selectedGender = gender;
                            });
                          },
                        ),
                        SizedBox(height: 3.h),

                        // Weight Input
                        WeightInputWidget(
                          controller: _weightController,
                          selectedUnit: _weightUnit,
                          onUnitChanged: (unit) {
                            setState(() {
                              _weightUnit = unit;
                            });
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 3.h),

                        // Height Input
                        HeightInputWidget(
                          heightController: _heightController,
                          feetController: _feetController,
                          inchesController: _inchesController,
                          selectedUnit: _heightUnit,
                          onUnitChanged: (unit) {
                            setState(() {
                              _heightUnit = unit;
                            });
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 3.h),

                        // Age Input
                        AgeInputWidget(
                          controller: _ageController,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 6.h),
                      ],
                    ),
                  ),
                ),
              ),

              // Continue Button
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                child: ElevatedButton(
                  onPressed:
                      _isFormValid() && !_isLoading ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid()
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    foregroundColor: _isFormValid()
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    elevation: _isFormValid() ? 2 : 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 5.w,
                          width: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Continue',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
