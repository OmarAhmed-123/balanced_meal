import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './ingredient_item_widget.dart';

class IngredientCategorySectionWidget extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final Function(String, int, int) onQuantityChanged;
  final Function(String, int) onItemRemoved;

  const IngredientCategorySectionWidget({
    super.key,
    required this.category,
    required this.items,
    required this.onQuantityChanged,
    required this.onItemRemoved,
  });

  @override
  State<IngredientCategorySectionWidget> createState() =>
      _IngredientCategorySectionWidgetState();
}

class _IngredientCategorySectionWidgetState
    extends State<IngredientCategorySectionWidget> {
  bool _isExpanded = true;

  IconData _getCategoryIcon() {
    switch (widget.category.toLowerCase()) {
      case 'meat':
        return Icons.restaurant;
      case 'vegetables':
        return Icons.eco;
      case 'carbs':
        return Icons.grain;
      default:
        return Icons.fastfood;
    }
  }

  Color _getCategoryColor() {
    switch (widget.category.toLowerCase()) {
      case 'meat':
        return Colors.red.shade400;
      case 'vegetables':
        return Colors.green.shade400;
      case 'carbs':
        return Colors.orange.shade400;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
              bottom: _isExpanded ? Radius.zero : Radius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: _getCategoryIcon().codePoint.toString(),
                      color: _getCategoryColor(),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${widget.items.length} item${widget.items.length > 1 ? 's' : ''}',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: AppTheme.lightTheme.dividerColor,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.lightTheme.dividerColor.withValues(alpha: 0.5),
              ),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return IngredientItemWidget(
                  item: item,
                  category: widget.category,
                  onQuantityChanged: widget.onQuantityChanged,
                  onItemRemoved: widget.onItemRemoved,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
