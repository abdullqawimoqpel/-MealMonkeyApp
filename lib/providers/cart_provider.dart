import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  Restaurant? _selectedRestaurant;
  double _deliveryFee = 8.0;
  double _taxRate = 0.15;

  List<CartItem> get items => _items;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  double get deliveryFee => _deliveryFee;
  double get taxRate => _taxRate;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get taxAmount => subtotal * _taxRate;

  double get total => subtotal + taxAmount + _deliveryFee;

  bool get isEmpty => _items.isEmpty;

  void addItem(MenuItem menuItem, Restaurant restaurant, {String? specialInstructions}) {
    // If cart is empty or from different restaurant, clear it
    if (_selectedRestaurant != null && _selectedRestaurant!.id != restaurant.id) {
      clearCart();
    }
    
    _selectedRestaurant = restaurant;

    // Check if item already exists
    final existingIndex = _items.indexWhere((item) => item.menuItem.id == menuItem.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        menuItem: menuItem,
        quantity: 1,
        specialInstructions: specialInstructions,
      ));
    }
    
    notifyListeners();
  }

  void removeItem(int menuItemId) {
    _items.removeWhere((item) => item.menuItem.id == menuItemId);
    
    if (_items.isEmpty) {
      _selectedRestaurant = null;
    }
    
    notifyListeners();
  }

  void updateQuantity(int menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }

    final index = _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _selectedRestaurant = null;
    notifyListeners();
  }

  CartItem? getItem(int menuItemId) {
    try {
      return _items.firstWhere((item) => item.menuItem.id == menuItemId);
    } catch (e) {
      return null;
    }
  }

  int getItemQuantity(int menuItemId) {
    final item = getItem(menuItemId);
    return item?.quantity ?? 0;
  }

  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
    notifyListeners();
  }
}

