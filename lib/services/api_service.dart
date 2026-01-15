import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/order.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api'; // للمحاكي Android
  static const Duration timeoutDuration = Duration(seconds: 10);

  // بيانات وهمية للاختبار
  static final List<Map<String, dynamic>> _mockRestaurants = [
    {
      'id': 1,
      'name': 'Chicken Palace',
      'name_ar': 'قصر الدجاج',
      'description': 'أفضل دجاج مقرمش في المدينة',
      'image_url': 'https://via.placeholder.com/300x200/FF6B35/FFFFFF?text=قصر+الدجاج',
      'rating': 4.5,
      'delivery_time': '25-35 دقيقة',
      'delivery_fee': 8.0,
      'category': 'دجاج مقرمش',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'id': 2,
      'name': 'Burger House',
      'name_ar': 'بيت البرجر',
      'description': 'برجر طازج ولذيذ',
      'image_url': 'https://via.placeholder.com/300x200/FF6B35/FFFFFF?text=بيت+البرجر',
      'rating': 4.2,
      'delivery_time': '20-30 دقيقة',
      'delivery_fee': 5.0,
      'category': 'برجر',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'id': 3,
      'name': 'Pizza Corner',
      'name_ar': 'ركن البيتزا',
      'description': 'بيتزا إيطالية أصيلة',
      'image_url': 'https://via.placeholder.com/300x200/FF6B35/FFFFFF?text=ركن+البيتزا',
      'rating': 4.7,
      'delivery_time': '30-40 دقيقة',
      'delivery_fee': 0.0,
      'category': 'بيتزا',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    },
  ];

  static final Map<int, List<Map<String, dynamic>>> _mockMenuItems = {
    1: [
      {
        'id': 1,
        'restaurant_id': 1,
        'name': 'Crispy Chicken',
        'name_ar': 'دجاج مقرمش',
        'description': 'قطع دجاج مقرمشة مع البهارات الخاصة',
        'price': 25.0,
        'image_url': 'https://via.placeholder.com/200x150/FF6B35/FFFFFF?text=دجاج+مقرمش',
        'category': 'الأطباق الرئيسية',
        'is_available': true,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 2,
        'restaurant_id': 1,
        'name': 'Chicken Wings',
        'name_ar': 'أجنحة الدجاج',
        'description': 'أجنحة دجاج حارة ولذيذة',
        'price': 18.0,
        'image_url': 'https://via.placeholder.com/200x150/FF6B35/FFFFFF?text=أجنحة+دجاج',
        'category': 'المقبلات',
        'is_available': true,
        'created_at': DateTime.now().toIso8601String(),
      },
    ],
    2: [
      {
        'id': 3,
        'restaurant_id': 2,
        'name': 'Classic Burger',
        'name_ar': 'برجر كلاسيكي',
        'description': 'برجر لحم بقري مع الخضار الطازجة',
        'price': 22.0,
        'image_url': 'https://via.placeholder.com/200x150/FF6B35/FFFFFF?text=برجر+كلاسيكي',
        'category': 'الأطباق الرئيسية',
        'is_available': true,
        'created_at': DateTime.now().toIso8601String(),
      },
    ],
    3: [
      {
        'id': 4,
        'restaurant_id': 3,
        'name': 'Margherita Pizza',
        'name_ar': 'بيتزا مارجريتا',
        'description': 'بيتزا كلاسيكية بالطماطم والجبن',
        'price': 35.0,
        'image_url': 'https://via.placeholder.com/200x150/FF6B35/FFFFFF?text=بيتزا+مارجريتا',
        'category': 'الأطباق الرئيسية',
        'is_available': true,
        'created_at': DateTime.now().toIso8601String(),
      },
    ],
  };

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/restaurants'))
          .timeout(timeoutDuration);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((json) => Restaurant.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('فشل في الاتصال بالخادم');
      }
    } catch (e) {
      // استخدام البيانات الوهمية في حالة فشل الاتصال
      print('فشل الاتصال بالخادم، استخدام البيانات الوهمية: $e');
      return _mockRestaurants
          .map((json) => Restaurant.fromJson(json))
          .toList();
    }
  }

  Future<Restaurant> getRestaurant(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/restaurants/$id'))
          .timeout(timeoutDuration);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return Restaurant.fromJson(data['data']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('فشل في الاتصال بالخادم');
      }
    } catch (e) {
      // استخدام البيانات الوهمية
      final restaurantData = _mockRestaurants.firstWhere(
        (r) => r['id'] == id,
        orElse: () => _mockRestaurants.first,
      );
      return Restaurant.fromJson(restaurantData);
    }
  }

  Future<List<MenuItem>> getMenuItems(int restaurantId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/restaurants/$restaurantId/menu'))
          .timeout(timeoutDuration);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data']['menu_items'] as List)
              .map((json) => MenuItem.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('فشل في الاتصال بالخادم');
      }
    } catch (e) {
      // استخدام البيانات الوهمية
      final menuItems = _mockMenuItems[restaurantId] ?? [];
      return menuItems.map((json) => MenuItem.fromJson(json)).toList();
    }
  }

  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/orders'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(orderData),
          )
          .timeout(timeoutDuration);
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          return Order.fromJson(data['data']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('فشل في إنشاء الطلب');
      }
    } catch (e) {
      // إنشاء طلب وهمي للاختبار
      final mockOrder = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'user_id': orderData['user_id'],
        'restaurant_id': orderData['restaurant_id'],
        'status': 'confirmed',
        'total_amount': 50.0,
        'delivery_fee': orderData['delivery_fee'] ?? 8.0,
        'tax_amount': 7.5,
        'delivery_address': orderData['delivery_address'],
        'delivery_phone': orderData['delivery_phone'],
        'notes': orderData['notes'],
        'estimated_delivery_time': orderData['estimated_delivery_time'] ?? 30,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      return Order.fromJson(mockOrder);
    }
  }

  Future<Order> getOrder(int orderId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/orders/$orderId'))
          .timeout(timeoutDuration);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return Order.fromJson(data['data']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('فشل في الاتصال بالخادم');
      }
    } catch (e) {
      // إرجاع طلب وهمي
      final mockOrder = {
        'id': orderId,
        'user_id': 1,
        'restaurant_id': 1,
        'status': 'preparing',
        'total_amount': 50.0,
        'delivery_fee': 8.0,
        'tax_amount': 7.5,
        'delivery_address': 'عنوان التوصيل',
        'delivery_phone': '+966501234567',
        'notes': null,
        'estimated_delivery_time': 25,
        'created_at': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      return Order.fromJson(mockOrder);
    }
  }

  Future<Map<String, dynamic>> trackOrder(int orderId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/orders/$orderId/track'))
          .timeout(timeoutDuration);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('فشل في الاتصال بالخادم');
      }
    } catch (e) {
      // إرجاع بيانات تتبع وهمية
      return {
        'order': {
          'id': orderId,
          'status': 'preparing',
          'estimated_delivery_time': 25,
        },
        'tracking_steps': [
          {'title': 'تم استلام الطلب', 'status': 'completed'},
          {'title': 'تم تأكيد الطلب', 'status': 'completed'},
          {'title': 'يتم تحضير الطلب', 'status': 'active'},
          {'title': 'الطلب في الطريق', 'status': 'pending'},
          {'title': 'تم التوصيل', 'status': 'pending'},
        ],
        'estimated_delivery_time': 25,
      };
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query, {String? category}) async {
    try {
      final uri = Uri.parse('$baseUrl/restaurants/search').replace(
        queryParameters: {
          if (query.isNotEmpty) 'q': query,
          if (category != null) 'category': category,
        },
      );
      
      final response = await http.get(uri).timeout(timeoutDuration);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((json) => Restaurant.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('فشل في البحث');
      }
    } catch (e) {
      // البحث في البيانات الوهمية
      final restaurants = _mockRestaurants
          .map((json) => Restaurant.fromJson(json))
          .toList();
      
      if (query.isEmpty && category == null) return restaurants;
      
      return restaurants.where((restaurant) {
        final matchesQuery = query.isEmpty ||
            restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.nameAr.contains(query) ||
            restaurant.category.toLowerCase().contains(query.toLowerCase());
        
        final matchesCategory = category == null ||
            restaurant.category.toLowerCase().contains(category.toLowerCase());
        
        return matchesQuery && matchesCategory;
      }).toList();
    }
  }
}

