import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calorie_tracker_widget.dart';
import './widgets/category_tab_widget.dart';
import './widgets/ingredient_card_widget.dart';
import './widgets/search_bar_widget.dart';

class IngredientSelection extends StatefulWidget {
  const IngredientSelection({super.key});

  @override
  State<IngredientSelection> createState() => _IngredientSelectionState();
}

class _IngredientSelectionState extends State<IngredientSelection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Mock user data for calorie calculation
  final double dailyCalorieNeeds = 2200.0;
  double currentCalories = 0.0;

  // Selected ingredients tracking
  Map<String, Map<String, dynamic>> selectedIngredients = {};

  // Search functionality
  String searchQuery = '';
  bool isLoading = false;

  // Mock ingredient data
  final List<Map<String, dynamic>> meatIngredients = [
    {
      "id": "meat_1",
      "name": "Grilled Chicken Breast",
      "calories": 165,
      "image":
          "https://images.pexels.com/photos/616354/pexels-photo-616354.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "meat",
      "protein": 31.0,
      "carbs": 0.0,
      "fat": 3.6,
      "price": 8.99
    },
    {
      "id": "meat_2",
      "name": "Lean Ground Beef",
      "calories": 250,
      "image":
          "https://images.pexels.com/photos/361184/asparagus-steak-veal-chop-veal-361184.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "meat",
      "protein": 26.0,
      "carbs": 0.0,
      "fat": 15.0,
      "price": 12.50
    },
    {
      "id": "meat_3",
      "name": "Salmon Fillet",
      "calories": 208,
      "image":
          "https://images.pexels.com/photos/725991/pexels-photo-725991.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "meat",
      "protein": 22.0,
      "carbs": 0.0,
      "fat": 12.0,
      "price": 15.99
    },
    {
      "id": "meat_4",
      "name": "Turkey Breast",
      "calories": 135,
      "image":
          "https://images.pexels.com/photos/8477/food-chicken-meat-roasted.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "meat",
      "protein": 30.0,
      "carbs": 0.0,
      "fat": 1.0,
      "price": 9.75
    }
  ];

  final List<Map<String, dynamic>> vegetableIngredients = [
    {
      "id": "veg_1",
      "name": "Fresh Broccoli",
      "calories": 34,
      "image":
          "https://images.pexels.com/photos/47347/broccoli-vegetable-food-healthy-47347.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "vegetables",
      "protein": 2.8,
      "carbs": 7.0,
      "fat": 0.4,
      "price": 3.25
    },
    {
      "id": "veg_2",
      "name": "Baby Spinach",
      "calories": 23,
      "image":
          "https://images.pexels.com/photos/2325843/pexels-photo-2325843.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "vegetables",
      "protein": 2.9,
      "carbs": 3.6,
      "fat": 0.4,
      "price": 4.50
    },
    {
      "id": "veg_3",
      "name": "Bell Peppers",
      "calories": 31,
      "image":
          "https://images.pexels.com/photos/594137/pexels-photo-594137.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "vegetables",
      "protein": 1.0,
      "carbs": 7.0,
      "fat": 0.3,
      "price": 2.99
    },
    {
      "id": "veg_4",
      "name": "Cherry Tomatoes",
      "calories": 18,
      "image":
          "https://images.pexels.com/photos/533280/pexels-photo-533280.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "vegetables",
      "protein": 0.9,
      "carbs": 3.9,
      "fat": 0.2,
      "price": 3.75
    },
    {
      "id": "veg_5",
      "name": "Avocado",
      "calories": 160,
      "image":
          "https://images.pexels.com/photos/557659/pexels-photo-557659.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "vegetables",
      "protein": 2.0,
      "carbs": 9.0,
      "fat": 15.0,
      "price": 2.50
    },
    {
      "id": "veg_6",
      "name": "Sweet Potato",
      "calories": 86,
      "image":
          "https://images.pexels.com/photos/89247/pexels-photo-89247.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "vegetables",
      "protein": 1.6,
      "carbs": 20.0,
      "fat": 0.1,
      "price": 1.99
    }
  ];

  final List<Map<String, dynamic>> carbIngredients = [
    {
      "id": "carb_1",
      "name": "Brown Rice",
      "calories": 111,
      "image":
          "https://images.pexels.com/photos/723198/pexels-photo-723198.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "carbs",
      "protein": 2.6,
      "carbs": 23.0,
      "fat": 0.9,
      "price": 2.25
    },
    {
      "id": "carb_2",
      "name": "Quinoa",
      "calories": 120,
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "carbs",
      "protein": 4.4,
      "carbs": 22.0,
      "fat": 1.9,
      "price": 4.99
    },
    {
      "id": "carb_3",
      "name": "Whole Wheat Pasta",
      "calories": 124,
      "image":
          "https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "carbs",
      "protein": 5.0,
      "carbs": 25.0,
      "fat": 1.1,
      "price": 3.50
    },
    {
      "id": "carb_4",
      "name": "Oats",
      "calories": 68,
      "image":
          "https://images.pexels.com/photos/216951/pexels-photo-216951.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "carbs",
      "protein": 2.4,
      "carbs": 12.0,
      "fat": 1.4,
      "price": 2.75
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      HapticFeedback.selectionClick();
    }
  }

  List<Map<String, dynamic>> _getCurrentIngredients() {
    List<Map<String, dynamic>> ingredients;
    switch (_tabController.index) {
      case 0:
        ingredients = meatIngredients;
        break;
      case 1:
        ingredients = vegetableIngredients;
        break;
      case 2:
        ingredients = carbIngredients;
        break;
      default:
        ingredients = meatIngredients;
    }

    if (searchQuery.isEmpty) {
      return ingredients;
    }

    return ingredients.where((ingredient) {
      return (ingredient['name'] as String)
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  void _updateIngredientQuantity(String ingredientId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        selectedIngredients.remove(ingredientId);
      } else {
        // Find ingredient in all categories
        Map<String, dynamic>? ingredient;
        for (var ingredientList in [
          meatIngredients,
          vegetableIngredients,
          carbIngredients
        ]) {
          try {
            ingredient =
                ingredientList.firstWhere((item) => item['id'] == ingredientId);
            break;
          } catch (e) {
            continue;
          }
        }

        if (ingredient != null) {
          selectedIngredients[ingredientId] = {
            ...ingredient,
            'quantity': quantity,
          };
        }
      }

      // Recalculate total calories
      currentCalories = selectedIngredients.values.fold(0.0, (sum, item) {
        return sum + ((item['calories'] as int) * (item['quantity'] as int));
      });
    });

    HapticFeedback.lightImpact();
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  Future<void> _refreshIngredients() async {
    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    HapticFeedback.mediumImpact();
  }

  void _showIngredientDetails(Map<String, dynamic> ingredient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageWidget(
                      imageUrl: ingredient['image'] as String,
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      ingredient['name'] as String,
                      style: AppTheme.lightTheme.textTheme.headlineSmall,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Nutritional Information (per serving)',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    _buildNutritionRow(
                        'Calories', '${ingredient['calories']} kcal'),
                    _buildNutritionRow('Protein', '${ingredient['protein']}g'),
                    _buildNutritionRow('Carbs', '${ingredient['carbs']}g'),
                    _buildNutritionRow('Fat', '${ingredient['fat']}g'),
                    SizedBox(height: 1.h),
                    _buildNutritionRow('Price', '\$${ingredient['price']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToOrder() {
    if (_isOrderButtonEnabled()) {
      HapticFeedback.mediumImpact();
      Navigator.pushNamed(context, '/order-summary');
    }
  }

  bool _isOrderButtonEnabled() {
    double percentage = (currentCalories / dailyCalorieNeeds) * 100;
    return percentage >= 90 && percentage <= 110;
  }

  int _getSelectedCountForCategory(String category) {
    return selectedIngredients.values
        .where((item) => item['category'] == category)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with calorie budget
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          'Build Your Meal',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Calorie progress bar
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily Calorie Goal',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              '${currentCalories.toInt()} / ${dailyCalorieNeeds.toInt()} kcal',
                              style: AppTheme.calorieTextStyle(isLight: true),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        LinearProgressIndicator(
                          value: currentCalories / dailyCalorieNeeds,
                          backgroundColor: AppTheme.lightTheme.dividerColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _isOrderButtonEnabled()
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${((currentCalories / dailyCalorieNeeds) * 100).toInt()}% of daily needs',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),

            // Category tabs
            CategoryTabWidget(
              tabController: _tabController,
              meatCount: _getSelectedCountForCategory('meat'),
              vegetableCount: _getSelectedCountForCategory('vegetables'),
              carbCount: _getSelectedCountForCategory('carbs'),
            ),

            // Ingredients grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshRefresh,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildIngredientsGrid(meatIngredients),
                          _buildIngredientsGrid(vegetableIngredients),
                          _buildIngredientsGrid(carbIngredients),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),

      // Floating calorie tracker and order button
      bottomNavigationBar: CalorieTrackerWidget(
        currentCalories: currentCalories,
        dailyCalorieNeeds: dailyCalorieNeeds,
        selectedItemsCount: selectedIngredients.length,
        isOrderEnabled: _isOrderButtonEnabled(),
        onOrderPressed: _proceedToOrder,
      ),
    );
  }

  Widget _buildIngredientsGrid(List<Map<String, dynamic>> ingredients) {
    final filteredIngredients = ingredients.where((ingredient) {
      return searchQuery.isEmpty ||
          (ingredient['name'] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
    }).toList();

    if (filteredIngredients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              searchQuery.isEmpty
                  ? 'No ingredients available'
                  : 'No ingredients found',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredIngredients.length,
      itemBuilder: (context, index) {
        final ingredient = filteredIngredients[index];
        final ingredientId = ingredient['id'] as String;
        final quantity = selectedIngredients[ingredientId]?['quantity'] ?? 0;

        return IngredientCardWidget(
          ingredient: ingredient,
          quantity: quantity,
          onQuantityChanged: (newQuantity) =>
              _updateIngredientQuantity(ingredientId, newQuantity),
          onLongPress: () => _showIngredientDetails(ingredient),
        );
      },
    );
  }

  Future<void> _refreshRefresh() async {
    await _refreshIngredients();
  }
}
