import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calorie_progress_card_widget.dart';
import './widgets/recent_orders_widget.dart';
import './widgets/weekly_stats_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "dailyCalories": 2200,
    "consumedCalories": 1650,
    "remainingCalories": 550,
    "weeklyAdherence": 85.5,
    "isOptimalRange": true,
  };

  // Mock recent orders data
  final List<Map<String, dynamic>> _recentOrders = [
    {
      "id": 1,
      "name": "Grilled Chicken Bowl",
      "calories": 450,
      "ingredients": ["Chicken", "Rice", "Broccoli"],
      "price": "\$12.99",
      "date": "Today",
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg",
    },
    {
      "id": 2,
      "name": "Salmon Quinoa Salad",
      "calories": 380,
      "ingredients": ["Salmon", "Quinoa", "Spinach"],
      "price": "\$14.50",
      "date": "Yesterday",
      "image":
          "https://images.pexels.com/photos/1640772/pexels-photo-1640772.jpeg",
    },
    {
      "id": 3,
      "name": "Veggie Power Bowl",
      "calories": 320,
      "ingredients": ["Tofu", "Sweet Potato", "Kale"],
      "price": "\$10.99",
      "date": "2 days ago",
      "image":
          "https://images.pexels.com/photos/1640773/pexels-photo-1640773.jpeg",
    },
  ];

  // Mock weekly stats data
  final List<Map<String, dynamic>> _weeklyStats = [
    {"day": "Mon", "adherence": 92.0},
    {"day": "Tue", "adherence": 88.0},
    {"day": "Wed", "adherence": 95.0},
    {"day": "Thu", "adherence": 82.0},
    {"day": "Fri", "adherence": 90.0},
    {"day": "Sat", "adherence": 78.0},
    {"day": "Sun", "adherence": 85.0},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _startNewOrder() {
    Navigator.pushNamed(context, '/ingredient-selection');
  }

  void _reorderMeal(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reordering ${order["name"]}...'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => Navigator.pushNamed(context, '/order-summary'),
        ),
      ),
    );
  }

  void _showOrderOptions(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Reorder'),
              onTap: () {
                Navigator.pop(context);
                _reorderMeal(order);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sharing ${order["name"]}...')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted ${order["name"]}')),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Balanced Meal',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user-profile-setup');
            },
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              text: 'Home',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Profile',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'History',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildProfileTab(),
          _buildHistoryTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _startNewOrder,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24,
              ),
              label: Text(
                'Start New Order',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            )
          : null,
    );
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calorie Progress Card
            CalorieProgressCardWidget(
              dailyCalories: _userData["dailyCalories"] as int,
              consumedCalories: _userData["consumedCalories"] as int,
              remainingCalories: _userData["remainingCalories"] as int,
              isOptimalRange: _userData["isOptimalRange"] as bool,
              isLoading: _isLoading,
            ),
            SizedBox(height: 4.h),

            // Quick Action Button
            if (_recentOrders.isEmpty) ...[
              _buildEmptyState(),
            ] else ...[
              // Recent Orders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Orders',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _tabController.animateTo(2),
                    child: Text('View All'),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              RecentOrdersWidget(
                orders: _recentOrders,
                onReorder: _reorderMeal,
                onLongPress: _showOrderOptions,
              ),
              SizedBox(height: 4.h),

              // Weekly Stats Section
              Text(
                'Weekly Progress',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              WeeklyStatsWidget(
                weeklyStats: _weeklyStats,
                averageAdherence: _userData["weeklyAdherence"] as double,
              ),
            ],
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'restaurant_menu',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Ready to start your nutrition journey?',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first balanced meal order based on your daily calorie needs.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _startNewOrder,
            child: Text('Create First Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Profile Settings',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage your personal information and dietary preferences',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/user-profile-setup'),
            child: Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Order History',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'View your complete meal ordering history and nutrition tracking',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
