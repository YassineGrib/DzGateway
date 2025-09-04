import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tourist_area_model.dart';

class TourismService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all active tourist areas
  Future<List<TouristArea>> getAllTouristAreas() async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_images(*)
          ''')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((area) => TouristArea.fromJson(area))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب المناطق السياحية: $e');
    }
  }

  // Get tourist area by ID
  Future<TouristArea?> getTouristAreaById(String areaId) async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_images(*)
          ''')
          .eq('id', areaId)
          .eq('is_active', true)
          .single();

      return TouristArea.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Search tourist areas
  Future<List<TouristArea>> searchTouristAreas(String query) async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_images(*)
          ''')
          .eq('is_active', true)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('rating', ascending: false);

      return (response as List)
          .map((area) => TouristArea.fromJson(area))
          .toList();
    } catch (e) {
      throw Exception('فشل في البحث عن المناطق السياحية: $e');
    }
  }

  // Get tourist areas by wilaya
  Future<List<TouristArea>> getTouristAreasByWilaya(String wilaya) async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_images(*)
          ''')
          .eq('is_active', true)
          .eq('wilaya', wilaya)
          .order('rating', ascending: false);

      return (response as List)
          .map((area) => TouristArea.fromJson(area))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب المناطق السياحية في $wilaya: $e');
    }
  }

  // Get tourist areas by category
  Future<List<TouristArea>> getTouristAreasByCategory(String category) async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_images(*)
          ''')
          .eq('is_active', true)
          .eq('category', category)
          .order('rating', ascending: false);

      return (response as List)
          .map((area) => TouristArea.fromJson(area))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب المناطق السياحية في فئة $category: $e');
    }
  }

  // Get top rated tourist areas
  Future<List<TouristArea>> getTopRatedTouristAreas({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_images(*)
          ''')
          .eq('is_active', true)
          .gte('rating', 4.0)
          .order('rating', ascending: false)
          .limit(limit);

      return (response as List)
          .map((area) => TouristArea.fromJson(area))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب أفضل المناطق السياحية: $e');
    }
  }

  // Create tourist area (Admin only)
  Future<TouristArea?> createTouristArea(Map<String, dynamic> areaData) async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .insert(areaData)
          .select()
          .single();

      return TouristArea.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إنشاء المنطقة السياحية: $e');
    }
  }

  // Update tourist area (Admin only)
  Future<TouristArea?> updateTouristArea(String areaId, Map<String, dynamic> areaData) async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .update(areaData)
          .eq('id', areaId)
          .select()
          .single();

      return TouristArea.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحديث المنطقة السياحية: $e');
    }
  }

  // Delete tourist area (Admin only)
  Future<bool> deleteTouristArea(String areaId) async {
    try {
      await _supabase
          .from('tourist_areas')
          .update({'is_active': false})
          .eq('id', areaId);
      return true;
    } catch (e) {
      throw Exception('فشل في حذف المنطقة السياحية: $e');
    }
  }

  // Get tourist area statistics
  Future<Map<String, dynamic>> getTouristAreaStatistics() async {
    try {
      final totalAreasResponse = await _supabase
          .from('tourist_areas')
          .select('id')
          .eq('is_active', true);

      final avgRating = await _supabase
          .rpc('get_average_tourist_area_rating');

      final topWilaya = await _supabase
          .rpc('get_top_tourist_area_wilaya');

      return {
        'total_areas': totalAreasResponse.length,
        'average_rating': avgRating ?? 0.0,
        'top_wilaya': topWilaya ?? 'غير محدد',
      };
    } catch (e) {
      return {
        'total_areas': 0,
        'average_rating': 0.0,
        'top_wilaya': 'غير محدد',
      };
    }
  }
}