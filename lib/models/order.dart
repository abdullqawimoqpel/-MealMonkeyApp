enum OrderStatus {
  pending,
  confirmed,
  preparing,
  onTheWay,
  delivered,
  cancelled,
}

class Order {
  final int id;
  final int userId;
  final int restaurantId;
  final OrderStatus status;
  final double totalAmount;
  final double deliveryFee;
  final double taxAmount;
  final String deliveryAddress;
  final String deliveryPhone;
  final String? notes;
  final int estimatedDeliveryTime;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.status,
    required this.totalAmount,
    required this.deliveryFee,
    required this.taxAmount,
    required this.deliveryAddress,
    required this.deliveryPhone,
    this.notes,
    required this.estimatedDeliveryTime,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      restaurantId: json['restaurant_id'],
      status: _parseOrderStatus(json['status']),
      totalAmount: json['total_amount'].toDouble(),
      deliveryFee: json['delivery_fee'].toDouble(),
      taxAmount: json['tax_amount'].toDouble(),
      deliveryAddress: json['delivery_address'],
      deliveryPhone: json['delivery_phone'],
      notes: json['notes'],
      estimatedDeliveryTime: json['estimated_delivery_time'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  static OrderStatus _parseOrderStatus(String status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'on_the_way':
        return OrderStatus.onTheWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  String get statusString {
    switch (status) {
      case OrderStatus.pending:
        return 'في الانتظار';
      case OrderStatus.confirmed:
        return 'تم التأكيد';
      case OrderStatus.preparing:
        return 'يتم التحضير';
      case OrderStatus.onTheWay:
        return 'في الطريق';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'status': status.toString().split('.').last,
      'total_amount': totalAmount,
      'delivery_fee': deliveryFee,
      'tax_amount': taxAmount,
      'delivery_address': deliveryAddress,
      'delivery_phone': deliveryPhone,
      'notes': notes,
      'estimated_delivery_time': estimatedDeliveryTime,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

