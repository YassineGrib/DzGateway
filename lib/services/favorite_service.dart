import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/favorite_model.dart';
import '../models/restaurant_model.dart';
import '../models/hotel_model.dart';

class FavoriteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // إضافة عنصر إلى المفضلة (مطعم أو فندق)
  Future<bool> addToFavorites(String itemId, FavoriteType itemType) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      await _supabase.from('user_favorites').insert({
        'user_id': user.id,
        'entity_type': itemType.name,
        'entity_id': itemId,
      });

      return true;
    } catch (e) {
      print('خطأ في إضافة العنصر إلى المفضلة: $e');
      return false;
    }
  }

  // إزالة عنصر من المفضلة
  Future<bool> removeFromFavorites(String itemId, FavoriteType itemType) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      await _supabase
          .from('user_favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('entity_type', itemType.name)
          .eq('entity_id', itemId);

      return true;
    } catch (e) {
      print('خطأ في إزالة العنصر من المفضلة: $e');
      return false;
    }
  }

  // التحقق من وجود عنصر في المفضلة
  Future<bool> isFavorite(String itemId, FavoriteType itemType) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return false;
      }

      final response = await _supabase
          .from('user_favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('entity_type', itemType.name)
          .eq('entity_id', itemId)
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

      final favoriteIds = await _supabase
          .from('user_favorites')
          .select('entity_id')
          .eq('user_id', user.id)
          .eq('entity_type', 'restaurant');

      if (favoriteIds.isEmpty) return [];

      final ids = favoriteIds.map((item) => item['entity_id']).toList();
      
      final response = await _supabase
          .from('restaurants')
          .select('*')
          .inFilter('id', ids);

      return response.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      print('خطأ في جلب المطاعم المفضلة: $e');
      return [];
    }
  }

  // جلب جميع الفنادق المفضلة للمستخدم
  Future<List<Hotel>> getFavoriteHotels() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      final favoriteIds = await _supabase
          .from('user_favorites')
          .select('entity_id')
          .eq('user_id', user.id)
          .eq('entity_type', 'hotel');

      if (favoriteIds.isEmpty) return [];

      final ids = favoriteIds.map((item) => item['item_id']).toList();
      
      final response = await _supabase
          .from('hotels')
          .select('*')
          .inFilter('id', ids);

      return response.map<Hotel>((json) => Hotel.fromJson(json)).toList();
    } catch (e) {
      print('خطأ في جلب الفنادق المفضلة: $e');
      return [];
    }
  }

  // جلب عدد العناصر المفضلة للمستخدم
  Future<int> getFavoritesCount({FavoriteType? itemType}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return 0;
      }

      var query = _supabase
          .from('user_favorites')
          .select('id')
          .eq('user_id', user.id);

      if (itemType != null) {
        query = query.eq('entity_type', itemType.name);
      }

      final response = await query;
      return (response as List).length;
    } catch (e) {
      print('خطأ في جلب عدد المفضلة: $e');
      return 0;
    }
  }

  // تبديل حالة المفضلة (إضافة أو إزالة)
  Future<bool> toggleFavorite(String itemId, FavoriteType itemType) async {
    try {
      final isFav = await isFavorite(itemId, itemType);
      if (isFav) {
        return await removeFromFavorites(itemId, itemType);
      } else {
        return await addToFavorites(itemId, itemType);
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