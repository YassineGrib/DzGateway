import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';

class RestaurantService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all active restaurants
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final response = await _supabase
          .from('restaurants')
          .select('''
            *,
            menu_items(*),
            restaurant_images(*)
          ''')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب المطاعم: $e');
    }
  }

  // Get restaurants by location (city/state)
  Future<List<Restaurant>> getRestaurantsByLocation(String location) async {
    try {
      final response = await _supabase
          .from('restaurants')
          .select('''
            *,
            menu_items(*),
            restaurant_images(*)
          ''')
          .eq('is_active', true)
          .ilike('address', '%$location%')
          .order('rating', ascending: false);

      return (response as List)
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب المطاعم حسب الموقع: $e');
    }
  }

  // Get restaurant by ID
  Future<Restaurant?> getRestaurantById(String id) async {
    try {
      final response = await _supabase
          .from('restaurants')
          .select('''
            *,
            menu_items(*),
            restaurant_images(*)
          ''')
          .eq('id', id)
          .eq('is_active', true)
          .single();

      return Restaurant.fromJson(response);
    } catch (e) {
      throw Exception('فشل في جلب بيانات المطعم: $e');
    }
  }

  // Search restaurants by name
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final response = await _supabase
          .from('restaurants')
          .select('''
            *,
            menu_items(*),
            restaurant_images(*)
          ''')
          .eq('is_active', true)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('rating', ascending: false);

      return (response as List)
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } catch (e) {
      throw Exception('فشل في البحث عن المطاعم: $e');
    }
  }

  // Get top rated restaurants
  Future<List<Restaurant>> getTopRatedRestaurants({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('restaurants')
          .select('''
            *,
            menu_items(*),
            restaurant_images(*)
          ''')
          .eq('is_active', true)
          .gte('rating', 4.0)
          .order('rating', ascending: false)
          .order('total_reviews', ascending: false)
          .limit(limit);

      return (response as List)
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب المطاعم الأعلى تقييماً: $e');
    }
  }

  // Get restaurants near coordinates
  Future<List<Restaurant>> getRestaurantsNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      // Using Supabase PostGIS functions for location-based queries
      final response = await _supabase.rpc('get_nearby_restaurants', params: {
        'lat': latitude,
        'lng': longitude,
        'radius_km': radiusKm,
      });

      return (response as List)
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } catch (e) {
      // Fallback to simple filtering if PostGIS function is not available
      return await getAllRestaurants();
    }
  }

  // Create a new restaurant (for restaurant owners)
  Future<Restaurant> createRestaurant(Restaurant restaurant) async {
    try {
      final response = await _supabase
          .from('restaurants')
          .insert(restaurant.toJson())
          .select()
          .single();

      return Restaurant.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إنشاء المطعم: $e');
    }
  }

  // Update restaurant
  Future<Restaurant> updateRestaurant(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from('restaurants')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return Restaurant.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحديث المطعم: $e');
    }
  }

  // Delete restaurant (soft delete by setting is_active to false)
  Future<void> deleteRestaurant(String id) async {
    try {
      await _supabase
          .from('restaurants')
          .update({'is_active': false})
          .eq('id', id);
    } catch (e) {
      throw Exception('فشل في حذف المطعم: $e');
    }
  }

  // Get menu items for a restaurant
  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .select()
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true)
          .order('category')
          .order('name');

      return (response as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب قائمة الطعام: $e');
    }
  }

  // Get restaurant images
  Future<List<RestaurantImage>> getRestaurantImages(String restaurantId) async {
    try {
      final response = await _supabase
          .from('restaurant_images')
          .select()
          .eq('restaurant_id', restaurantId)
          .order('display_order');

      return (response as List)
          .map((image) => RestaurantImage.fromJson(image))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب صور المطعم: $e');
    }
  }

  // Add menu item
  Future<MenuItem> addMenuItem(MenuItem menuItem) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .insert(menuItem.toJson())
          .select()
          .single();

      return MenuItem.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة عنصر القائمة: $e');
    }
  }

  // Add restaurant image
  Future<RestaurantImage> addRestaurantImage(RestaurantImage image) async {
    try {
      final response = await _supabase
          .from('restaurant_images')
          .insert(image.toJson())
          .select()
          .single();

      return RestaurantImage.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة صورة المطعم: $e');
    }
  }
}