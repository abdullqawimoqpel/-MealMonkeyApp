import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final Restaurant restaurant;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final quantity = cart.getItemQuantity(menuItem.id);
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Menu Item Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: menuItem.imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: menuItem.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.fastfood,
                                size: 32,
                                color: AppColors.textLight,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.fastfood,
                            size: 32,
                            color: AppColors.textLight,
                          ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Menu Item Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Name
                      Text(
                        menuItem.nameAr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      // Item Description
                      Text(
                        menuItem.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      // Price and Add Button
                      Row(
                        children: [
                          // Price
                          Text(
                            '${menuItem.price.toStringAsFixed(0)} ر.س',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          
                          // Add/Remove Buttons
                          if (quantity == 0)
                            // Add Button
                            ElevatedButton(
                              onPressed: menuItem.isAvailable
                                  ? () {
                                      cart.addItem(menuItem, restaurant);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'تم إضافة ${menuItem.nameAr} إلى السلة',
                                          ),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                minimumSize: const Size(0, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'إضافة',
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                          else
                            // Quantity Controls
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Decrease Button
                                  InkWell(
                                    onTap: () {
                                      cart.updateQuantity(
                                        menuItem.id,
                                        quantity - 1,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  
                                  // Quantity
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  
                                  // Increase Button
                                  InkWell(
                                    onTap: () {
                                      cart.updateQuantity(
                                        menuItem.id,
                                        quantity + 1,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

