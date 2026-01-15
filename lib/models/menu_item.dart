class MenuItem {
  final int id;
  final int restaurantId;
  final String name;
  final String nameAr;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final DateTime createdAt;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.createdAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      name: json['name'],
      nameAr: json['name_ar'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
      category: json['category'],
      isAvailable: json['is_available'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

