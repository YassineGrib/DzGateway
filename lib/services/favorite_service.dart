import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/favorite_model.dart';
import '../models/restaurant_model.dart';

class FavoriteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // إضافة مطعم إلى المفضلة
  Future<bool> addToFavorites(String restaurantId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      await _supabase.from('user_favorites').insert({
        'user_id': user.id,
        'restaurant_id': restaurantId,
      });

      return true;
    } catch (e) {
      print('خطأ في إضافة المطعم إلى المفضلة: $e');
      return false;
    }
  }

  // إزالة مطعم من المفضلة
  Future<bool> removeFromFavorites(String restaurantId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      await _supabase
          .from('user_favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('restaurant_id', restaurantId);

      return true;
    } catch (e) {
      print('خطأ في إزالة المطعم من المفضلة: $e');
      return false;
    }
  }

  // التحقق من وجود مطعم في المفضلة
  Future<bool> isFavorite(String restaurantId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return false;
      }

      final response = await _supabase
          .from('user_favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('restaurant_id', restaurantId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('خطأ في التحقق من المفضلة: $e');
      return false;
    }
  }

  // جلب جميع المطاعم المفضلة للمستخدم
  Future<List<Restaurant>> getFavoriteRestaurants() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      final response = await _supabase
          .from('user_favorites')
          .select('''
            restaurants (
              id,
              name,
              address,
              latitude,
              longitude,
              phone,
              description,
              cover_image,
              rating,
              total_reviews,
              is_active,
              created_at,
              updated_at
            )
          ''')
          .eq('user_id', user.id);

      final List<Restaurant> restaurants = [];
      for (final item in response) {
        if (item['restaurants'] != null) {
          restaurants.add(Restaurant.fromJson(item['restaurants']));
        }
      }

      return restaurants;
    } catch (e) {
      print('خطأ في جلب المطاعم المفضلة: $e');
      return [];
    }
  }

  // جلب عدد المطاعم المفضلة للمستخدم
  Future<int> getFavoritesCount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return 0;
      }

      final response = await _supabase
          .from('user_favorites')
          .select('id')
          .eq('user_id', user.id);

      return (response as List).length;
    } catch (e) {
      print('خطأ في جلب عدد المفضلة: $e');
      return 0;
    }
  }

  // تبديل حالة المفضلة (إضافة أو إزالة)
  Future<bool> toggleFavorite(String restaurantId) async {
    try {
      final isFav = await isFavorite(restaurantId);
      if (isFav) {
        return await removeFromFavorites(restaurantId);
      } else {
        return await addToFavorites(restaurantId);
      }
    } catch (e) {
      print('خطأ في تبديل المفضلة: $e');
      return false;
    }
  }

  // جلب قائمة المفضلة مع معلومات إضافية
  Future<List<Favorite>> getUserFavorites() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      final response = await _supabase
          .from('user_favorites')
          .select('*')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return response.map<Favorite>((json) => Favorite.fromJson(json)).toList();
    } catch (e) {
      print('خطأ في جلب قائمة المفضلة: $e');
      return [];
    }
  }
}