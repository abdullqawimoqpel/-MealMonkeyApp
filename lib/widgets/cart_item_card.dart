import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Item Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: cartItem.menuItem.imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: cartItem.menuItem.imageUrl,
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
                          size: 24,
                          color: AppColors.textLight,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.fastfood,
                      size: 24,
                      color: AppColors.textLight,
                    ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                Text(
                  cartItem.menuItem.nameAr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Unit Price
                Text(
                  '${cartItem.menuItem.price.toStringAsFixed(0)} ر.س',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                // Special Instructions
                if (cartItem.specialInstructions != null &&
                    cartItem.specialInstructions!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'ملاحظات: ${cartItem.specialInstructions}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Quantity Controls and Total Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Total Price
              Text(
                '${cartItem.totalPrice.toStringAsFixed(0)} ر.س',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              
              // Quantity Controls
              Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Decrease Button
                        InkWell(
                          onTap: () {
                            cart.updateQuantity(
                              cartItem.menuItem.id,
                              cartItem.quantity - 1,
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
                            cartItem.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        
                        // Increase Button
                        InkWell(
                          onTap: () {
                            cart.updateQuantity(
                              cartItem.menuItem.id,
                              cartItem.quantity + 1,
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
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

