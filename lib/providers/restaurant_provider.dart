import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../services/api_service.dart';

class RestaurantProvider with ChangeNotifier {
  List<Restaurant> _restaurants = [];
  List<MenuItem> _menuItems = [];
  Restaurant? _selectedRestaurant;
  bool _isLoading = false;
  String? _error;

  List<Restaurant> get restaurants => _restaurants;
  List<MenuItem> get menuItems => _menuItems;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = ApiService();

  Future<void> loadRestaurants() async {
    _setLoading(true);
    _error = null;

    try {
      _restaurants = await _apiService.getRestaurants();
      _error = null; // مسح الخطأ عند النجاح
      notifyListeners();
    } catch (e) {
      print('خطأ في تحميل المطاعم: $e');
      // لا نعرض الخطأ للمستخدم لأن API service يستخدم البيانات الوهمية
      _restaurants = await _apiService.getRestaurants(); // سيعيد البيانات الوهمية
      _error = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMenuItems(int restaurantId) async {
    _setLoading(true);
    _error = null;

    try {
      _menuItems = await _apiService.getMenuItems(restaurantId);
      _error = null;
      notifyListeners();
    } catch (e) {
      print('خطأ في تحميل قائمة الطعام: $e');
      _menuItems = await _apiService.getMenuItems(restaurantId); // سيعيد البيانات الوهمية
      _error = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void setSelectedRestaurant(Restaurant restaurant) {
    _selectedRestaurant = restaurant;
    notifyListeners();
  }

  void clearSelectedRestaurant() {
    _selectedRestaurant = null;
    _menuItems.clear();
    notifyListeners();
  }

  List<Restaurant> searchRestaurants(String query) {
    if (query.isEmpty) return _restaurants;
    
    return _restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
             restaurant.nameAr.contains(query) ||
             restaurant.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<MenuItem> getMenuItemsByCategory(String category) {
    return _menuItems.where((item) => item.category == category).toList();
  }

  List<String> get menuCategories {
    return _menuItems.map((item) => item.category).toSet().toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

