class Restaurant {
  final int id;
  final String name;
  final String nameAr;
  final String description;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final double deliveryFee;
  final String category;
  final bool isActive;
  final DateTime createdAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.category,
    required this.isActive,
    required this.createdAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      description: json['description'],
      imageUrl: json['image_url'],
      rating: json['rating'].toDouble(),
      deliveryTime: json['delivery_time'],
      deliveryFee: json['delivery_fee'].toDouble(),
      category: json['category'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'image_url': imageUrl,
      'rating': rating,
      'delivery_time': deliveryTime,
      'delivery_fee': deliveryFee,
      'category': category,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

