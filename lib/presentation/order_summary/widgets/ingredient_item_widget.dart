import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IngredientItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final String category;
  final Function(String, int, int) onQuantityChanged;
  final Function(String, int) onItemRemoved;

  const IngredientItemWidget({
    super.key,
    required this.item,
    required this.category,
    required this.onQuantityChanged,
    required this.onItemRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${category}_${item["id"]}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Remove Item',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  content: Text(
                    'Remove ${item["name"]} from your order?',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Remove',
                        style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.error),
                      ),
                    ),
                  ],
                );
              },
            ) ??
            false;
      },
      onDismissed: (direction) {
        onItemRemoved(category, item["id"] as int);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        color: AppTheme.lightTheme.colorScheme.error,
        child: CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 24,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            // Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: item["image"] as String,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 3.w),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"] as String,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        '\$${(item["pricePerUnit"] as double).toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${item["caloriesPerUnit"]} cal',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        'Total: \$${(item["totalPrice"] as double).toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${item["totalCalories"]} cal',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 3.w),

            // Quantity Controls
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      final currentQuantity = item["quantity"] as int;
                      if (currentQuantity > 1) {
                        onQuantityChanged(
                            category, item["id"] as int, currentQuantity - 1);
                        HapticFeedback.lightImpact();
                      }
                    },
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(8)),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'remove',
                        color: (item["quantity"] as int) > 1
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.outline,
                        size: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color: AppTheme.lightTheme.dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      '${item["quantity"]}',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final currentQuantity = item["quantity"] as int;
                      onQuantityChanged(
                          category, item["id"] as int, currentQuantity + 1);
                      HapticFeedback.lightImpact();
                    },
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(8)),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 16,
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
}
