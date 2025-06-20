import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calorie_summary_card_widget.dart';
import './widgets/ingredient_category_section_widget.dart';
import './widgets/order_actions_widget.dart';
import './widgets/order_totals_widget.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  bool _isLoading = false;
  final Dio _dio = Dio();

  // Mock order data
  final Map<String, dynamic> _orderData = {
    "dailyCalorieRequirement": 2200,
    "totalCaloriesSelected": 2100,
    "caloriePercentage": 95.5,
    "isOptimalRange": true,
    "selectedIngredients": {
      "Meat": [
        {
          "id": 1,
          "name": "Grilled Chicken Breast",
          "image":
              "https://images.pexels.com/photos/2338407/pexels-photo-2338407.jpeg?auto=compress&cs=tinysrgb&w=500",
          "quantity": 2,
          "pricePerUnit": 8.50,
          "caloriesPerUnit": 165,
          "totalPrice": 17.00,
          "totalCalories": 330
        },
        {
          "id": 2,
          "name": "Lean Ground Beef",
          "image":
              "https://images.pexels.com/photos/361184/asparagus-steak-veal-chop-veal-361184.jpeg?auto=compress&cs=tinysrgb&w=500",
          "quantity": 1,
          "pricePerUnit": 12.00,
          "caloriesPerUnit": 250,
          "totalPrice": 12.00,
          "totalCalories": 250
        }
      ],
      "Vegetables": [
        {
          "id": 3,
          "name": "Fresh Broccoli",
          "image":
              "https://images.pexels.com/photos/47347/broccoli-vegetable-food-healthy-47347.jpeg?auto=compress&cs=tinysrgb&w=500",
          "quantity": 3,
          "pricePerUnit": 2.50,
          "caloriesPerUnit": 55,
          "totalPrice": 7.50,
          "totalCalories": 165
        },
        {
          "id": 4,
          "name": "Mixed Bell Peppers",
          "image":
              "https://images.pexels.com/photos/1268101/pexels-photo-1268101.jpeg?auto=compress&cs=tinysrgb&w=500",
          "quantity": 2,
          "pricePerUnit": 3.25,
          "caloriesPerUnit": 30,
          "totalPrice": 6.50,
          "totalCalories": 60
        },
        {
          "id": 5,
          "name": "Baby Spinach",
          "image":
              "https://images.pexels.com/photos/2325843/pexels-photo-2325843.jpeg?auto=compress&cs=tinysrgb&w=500",
          "quantity": 1,
          "pricePerUnit": 4.00,
          "caloriesPerUnit": 23,
          "totalPrice": 4.00,
          "totalCalories": 23
        }
      ],
      "Carbs": [
        {
          "id": 6,
          "name": "Brown Rice",
          "image":
              "https://images.pexels.com/photos/723198/pexels-photo-723198.jpeg?auto=compress&cs=tinysrgb&w=500",
          "quantity": 2,
          "pricePerUnit": 3.75,
          "caloriesPerUnit": 216,
          "totalPrice": 7.50,
          "totalCalories": 432
        },
        {
          "id": 7,
          "name": "Sweet Potato",
          "image":
              "https://images.pexels.com/photos/89247/pexels-photo-89247.jpeg?auto=compress&cs=tinysrgb&w=500",
          "quantity": 3,
          "pricePerUnit": 2.00,
          "caloriesPerUnit": 112,
          "totalPrice": 6.00,
          "totalCalories": 336
        },
        {
          "id": 8,
          "name": "Quinoa",
          "image":
              "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=500",
          "quantity": 1,
          "pricePerUnit": 5.50,
          "caloriesPerUnit": 222,
          "totalPrice": 5.50,
          "totalCalories": 222
        }
      ]
    },
    "subtotal": 66.00,
    "tax": 5.28,
    "deliveryFee": 3.99,
    "total": 75.27
  };

  void _updateQuantity(String category, int itemId, int newQuantity) {
    setState(() {
      final categoryItems =
          (_orderData["selectedIngredients"][category] as List);
      final itemIndex = categoryItems
          .indexWhere((item) => (item as Map<String, dynamic>)["id"] == itemId);

      if (itemIndex != -1) {
        final item = categoryItems[itemIndex] as Map<String, dynamic>;
        if (newQuantity <= 0) {
          _showDeleteConfirmation(category, itemId);
          return;
        }

        item["quantity"] = newQuantity;
        item["totalPrice"] = (item["pricePerUnit"] as double) * newQuantity;
        item["totalCalories"] = (item["caloriesPerUnit"] as int) * newQuantity;

        _recalculateOrderTotals();
        HapticFeedback.lightImpact();
      }
    });
  }

  void _removeItem(String category, int itemId) {
    setState(() {
      final categoryItems =
          (_orderData["selectedIngredients"][category] as List);
      categoryItems.removeWhere(
          (item) => (item as Map<String, dynamic>)["id"] == itemId);
      _recalculateOrderTotals();
      HapticFeedback.mediumImpact();
    });
  }

  void _showDeleteConfirmation(String category, int itemId) {
    final categoryItems = (_orderData["selectedIngredients"][category] as List);
    final item = categoryItems.firstWhere(
            (item) => (item as Map<String, dynamic>)["id"] == itemId)
        as Map<String, dynamic>;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Item',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to remove ${item["name"]} from your order?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeItem(category, itemId);
              },
              child: Text(
                'Remove',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _recalculateOrderTotals() {
    double subtotal = 0.0;
    int totalCalories = 0;

    (_orderData["selectedIngredients"] as Map<String, dynamic>)
        .forEach((category, items) {
      for (var item in (items as List)) {
        final itemMap = item as Map<String, dynamic>;
        subtotal += itemMap["totalPrice"] as double;
        totalCalories += itemMap["totalCalories"] as int;
      }
    });

    final tax = subtotal * 0.08;
    final total = subtotal + tax + (_orderData["deliveryFee"] as double);

    _orderData["subtotal"] = subtotal;
    _orderData["tax"] = tax;
    _orderData["total"] = total;
    _orderData["totalCaloriesSelected"] = totalCalories;
    _orderData["caloriePercentage"] =
        (totalCalories / (_orderData["dailyCalorieRequirement"] as int)) * 100;
    _orderData["isOptimalRange"] = _orderData["caloriePercentage"] >= 90 &&
        _orderData["caloriePercentage"] <= 110;
  }

  Future<void> _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Mock API endpoint
      final response = await _dio.post(
        'https://api.balancedmeal.com/orders',
        data: {
          'order_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'items': _formatOrderItems(),
          'totals': {
            'subtotal': _orderData["subtotal"],
            'tax': _orderData["tax"],
            'delivery_fee': _orderData["deliveryFee"],
            'total': _orderData["total"]
          },
          'nutrition': {
            'total_calories': _orderData["totalCaloriesSelected"],
            'daily_requirement': _orderData["dailyCalorieRequirement"],
            'percentage': _orderData["caloriePercentage"]
          },
          'timestamp': DateTime.now().toIso8601String()
        },
      );

      HapticFeedback.heavyImpact();

      Fluttertoast.showToast(
        msg: "Order placed successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: Colors.white,
      );

      // Navigate to home after successful order
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home-dashboard',
        (route) => false,
      );
    } catch (e) {
      _showErrorDialog('Failed to place order. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _formatOrderItems() {
    List<Map<String, dynamic>> formattedItems = [];

    (_orderData["selectedIngredients"] as Map<String, dynamic>)
        .forEach((category, items) {
      for (var item in (items as List)) {
        final itemMap = item as Map<String, dynamic>;
        formattedItems.add({
          'id': itemMap["id"],
          'name': itemMap["name"],
          'category': category,
          'quantity': itemMap["quantity"],
          'unit_price': itemMap["pricePerUnit"],
          'total_price': itemMap["totalPrice"],
          'calories_per_unit': itemMap["caloriesPerUnit"],
          'total_calories': itemMap["totalCalories"]
        });
      }
    });

    return formattedItems;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Order Failed',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _placeOrder();
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  void _editOrder() {
    Navigator.pushNamed(context, '/ingredient-selection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Review Order',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Calorie Summary Card
                    CalorieSummaryCardWidget(
                      dailyRequirement:
                          _orderData["dailyCalorieRequirement"] as int,
                      totalSelected: _orderData["totalCaloriesSelected"] as int,
                      percentage: _orderData["caloriePercentage"] as double,
                      isOptimal: _orderData["isOptimalRange"] as bool,
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      'Selected Ingredients',
                      style: AppTheme.lightTheme.textTheme.headlineSmall,
                    ),

                    SizedBox(height: 2.h),

                    // Ingredient Categories
                    ...(_orderData["selectedIngredients"]
                            as Map<String, dynamic>)
                        .entries
                        .map((entry) {
                      final category = entry.key;
                      final items = entry.value as List;

                      return items.isNotEmpty
                          ? IngredientCategorySectionWidget(
                              category: category,
                              items: items.cast<Map<String, dynamic>>(),
                              onQuantityChanged: _updateQuantity,
                              onItemRemoved: _removeItem,
                            )
                          : SizedBox.shrink();
                    }),

                    SizedBox(height: 3.h),

                    // Order Totals
                    OrderTotalsWidget(
                      subtotal: _orderData["subtotal"] as double,
                      tax: _orderData["tax"] as double,
                      deliveryFee: _orderData["deliveryFee"] as double,
                      total: _orderData["total"] as double,
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            // Order Actions
            OrderActionsWidget(
              isLoading: _isLoading,
              onPlaceOrder: _placeOrder,
              onEditOrder: _editOrder,
            ),
          ],
        ),
      ),
    );
  }
}
