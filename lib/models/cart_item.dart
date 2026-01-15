import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  final String? specialInstructions;

  CartItem({
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
  });

  double get totalPrice => menuItem.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItem.id,
      'quantity': quantity,
      'special_instructions': specialInstructions,
    };
  }

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

