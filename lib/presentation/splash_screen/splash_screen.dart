import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/loading_progress_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _progressAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate Firebase initialization
      setState(() {
        _loadingText = 'Connecting to Firebase...';
      });
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate ingredient data loading
      setState(() {
        _loadingText = 'Loading ingredient data...';
      });
      await Future.delayed(const Duration(milliseconds: 700));

      // Simulate BMR calculation setup
      setState(() {
        _loadingText = 'Preparing calculations...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Check authentication status (simulated)
      setState(() {
        _loadingText = 'Checking user session...';
      });
      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        _isInitialized = true;
        _loadingText = 'Ready!';
      });

      // Haptic feedback for successful initialization
      HapticFeedback.lightImpact();

      // Navigate after brief delay
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen();
    } catch (error) {
      setState(() {
        _hasError = true;
        _loadingText = 'Connection failed';
      });

      // Show retry option after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _hasError) {
          _showRetryOption();
        }
      });
    }
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // Simulate checking if user is returning or new
    bool isReturningUser = false; // This would come from shared preferences

    if (isReturningUser) {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/welcome-screen');
    }
  }

  void _showRetryOption() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Connection Error',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Unable to connect to the server. Please check your internet connection and try again.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _hasError = false;
                _loadingText = 'Retrying...';
              });
              _initializeApp();
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/welcome-screen');
            },
            child: const Text('Continue Offline'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primaryContainer,
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.8),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated Logo Section
              AnimatedLogoWidget(
                animation: _logoScaleAnimation,
              ),

              SizedBox(height: 8.h),

              // App Name
              Text(
                'Balanced Meal',
                style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 2.h),

              // Tagline
              Text(
                'Nutrition Made Simple',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),

              const Spacer(flex: 2),

              // Loading Progress Section
              LoadingProgressWidget(
                animation: _progressAnimation,
                loadingText: _loadingText,
                hasError: _hasError,
                isInitialized: _isInitialized,
              ),

              SizedBox(height: 6.h),

              // Error retry button (only shown when there's an error)
              if (_hasError)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _loadingText = 'Retrying...';
                      });
                      _initializeApp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                      minimumSize: Size(double.infinity, 6.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Retry Connection',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
