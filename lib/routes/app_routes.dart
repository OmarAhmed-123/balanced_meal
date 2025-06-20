// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/ingredient_selection/ingredient_selection.dart';
import '../presentation/user_profile_setup/user_profile_setup.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/order_summary/order_summary.dart';
import '../presentation/database_configuration_screen/database_configuration_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String welcomeScreen = '/welcome-screen';
  static const String userProfileSetup = '/user-profile-setup';
  static const String homeDashboard = '/home-dashboard';
  static const String ingredientSelection = '/ingredient-selection';
  static const String orderSummary = '/order-summary';
  static const String databaseConfigurationScreen =
      '/database-configuration-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    welcomeScreen: (context) => const WelcomeScreen(),
    userProfileSetup: (context) => const UserProfileSetup(),
    homeDashboard: (context) => const HomeDashboard(),
    ingredientSelection: (context) => const IngredientSelection(),
    orderSummary: (context) => const OrderSummary(),
    databaseConfigurationScreen: (context) =>
        const DatabaseConfigurationScreen(),
  };
}
