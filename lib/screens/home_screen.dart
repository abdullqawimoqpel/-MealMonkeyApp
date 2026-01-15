import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/loading_widget.dart';
import 'restaurant_menu_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().loadRestaurants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Meal Monkey',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحباً! ماذا تريد أن تأكل اليوم؟',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                CustomSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  hintText: 'ابحث عن المطاعم أو الأطباق...',
                ),
              ],
            ),
          ),
          
          // Categories Section
          Container(
            height: 60,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('الكل', ''),
                _buildCategoryChip('دجاج مقرمش', 'دجاج مقرمش'),
                _buildCategoryChip('برجر', 'برجر'),
                _buildCategoryChip('بيتزا', 'بيتزا'),
                _buildCategoryChip('مأكولات بحرية', 'مأكولات بحرية'),
                _buildCategoryChip('حلويات', 'حلويات'),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Restaurants List
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const LoadingWidget(
                    message: 'جاري تحميل المطاعم...',
                  );
                }

                if (provider.error != null) {
                  return CustomErrorWidget(
                    message: 'حدث خطأ في تحميل البيانات',
                    onRetry: () => provider.loadRestaurants(),
                  );
                }

                final restaurants = _searchQuery.isEmpty
                    ? provider.restaurants
                    : provider.searchRestaurants(_searchQuery);

                if (restaurants.isEmpty) {
                  return EmptyStateWidget(
                    message: _searchQuery.isEmpty 
                        ? 'لا توجد مطاعم متاحة'
                        : 'لا توجد نتائج للبحث',
                    subtitle: _searchQuery.isEmpty 
                        ? 'سيتم إضافة المطاعم قريباً'
                        : 'جرب البحث بكلمات أخرى',
                    icon: _searchQuery.isEmpty 
                        ? Icons.restaurant_outlined
                        : Icons.search_off,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RestaurantCard(
                        restaurant: restaurant,
                        onTap: () {
                          provider.setSelectedRestaurant(restaurant);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RestaurantMenuScreen(
                                restaurant: restaurant,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: false,
        onSelected: (selected) {
          // Handle category selection
          setState(() {
            _searchQuery = category;
          });
        },
        backgroundColor: Colors.grey[100],
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide.none,
      ),
    );
  }
}

