import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tourist_area_model.dart';

class TouristAreaService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // الحصول على جميع المناطق السياحية النشطة
  static Future<List<TouristArea>> getAllTouristAreas() async {
    try {
      print('🔍 Fetching all tourist areas...');
      
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_features(*),
            tourist_area_images(*),
            tourist_area_tips(*)
          ''')
          .eq('is_active', true)
          .order('rating', ascending: false);
      
      print('📊 Raw tourist areas response: $response');
      print('📊 Response type: ${response.runtimeType}');
      print('📊 Response length: ${response.length}');
      
      if (response.isEmpty) {
        print('⚠️ No tourist areas found');
        return [];
      }
      
      final areas = response.map((area) => TouristArea.fromJson(area)).toList();
      print('✅ Successfully loaded ${areas.length} tourist areas');
      
      return areas;
    } catch (e, stackTrace) {
      print('❌ Error fetching tourist areas: $e');
      print('📍 Stack trace: $stackTrace');
      throw Exception('فشل في تحميل المناطق السياحية: $e');
    }
  }

  // الحصول على منطقة سياحية محددة بالمعرف
  static Future<TouristArea?> getTouristAreaById(String id) async {
    try {
      print('🔍 Fetching tourist area with ID: $id');
      
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_features(*),
            tourist_area_images(*),
            tourist_area_tips(*)
          ''')
          .eq('id', id)
          .eq('is_active', true)
          .single();
      
      print('📊 Tourist area response: $response');
      
      return TouristArea.fromJson(response);
    } catch (e) {
      print('❌ Error fetching tourist area by ID: $e');
      return null;
    }
  }

  // البحث في المناطق السياحية
  static Future<List<TouristArea>> searchTouristAreas({
    String? query,
    String? city,
    String? wilaya,
    String? areaType,
    double? minRating,
  }) async {
    try {
      print('🔍 Searching tourist areas with query: $query');
      
      var queryBuilder = _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_features(*),
            tourist_area_images(*),
            tourist_area_tips(*)
          ''')
          .eq('is_active', true);
      
      if (query != null && query.isNotEmpty) {
        queryBuilder = queryBuilder.or('name.ilike.%$query%,description.ilike.%$query%');
      }
      
      if (city != null && city.isNotEmpty) {
        queryBuilder = queryBuilder.eq('city', city);
      }
      
      if (wilaya != null && wilaya.isNotEmpty) {
        queryBuilder = queryBuilder.eq('wilaya', wilaya);
      }
      
      if (areaType != null && areaType.isNotEmpty) {
        queryBuilder = queryBuilder.eq('area_type', areaType);
      }
      
      if (minRating != null) {
        queryBuilder = queryBuilder.gte('rating', minRating);
      }
      
      final response = await queryBuilder.order('rating', ascending: false);
      
      print('📊 Search results: ${response.length} areas found');
      
      return response.map((area) => TouristArea.fromJson(area)).toList();
    } catch (e) {
      print('❌ Error searching tourist areas: $e');
      throw Exception('فشل في البحث عن المناطق السياحية: $e');
    }
  }

  // الحصول على المناطق السياحية الأعلى تقييماً
  static Future<List<TouristArea>> getTopRatedTouristAreas({int limit = 10}) async {
    try {
      print('🔍 Fetching top rated tourist areas...');
      
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_features(*),
            tourist_area_images(*),
            tourist_area_tips(*)
          ''')
          .eq('is_active', true)
          .gte('rating', 4.0)
          .order('rating', ascending: false)
          .order('total_reviews', ascending: false)
          .limit(limit);
      
      print('📊 Top rated areas: ${response.length} found');
      
      return response.map((area) => TouristArea.fromJson(area)).toList();
    } catch (e) {
      print('❌ Error fetching top rated tourist areas: $e');
      throw Exception('فشل في تحميل المناطق السياحية الأعلى تقييماً: $e');
    }
  }

  // الحصول على المناطق السياحية حسب الولاية
  static Future<List<TouristArea>> getTouristAreasByWilaya(String wilaya) async {
    try {
      print('🔍 Fetching tourist areas for wilaya: $wilaya');
      
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_features(*),
            tourist_area_images(*),
            tourist_area_tips(*)
          ''')
          .eq('wilaya', wilaya)
          .eq('is_active', true)
          .order('rating', ascending: false);
      
      print('📊 Areas in $wilaya: ${response.length} found');
      
      return response.map((area) => TouristArea.fromJson(area)).toList();
    } catch (e) {
      print('❌ Error fetching tourist areas by wilaya: $e');
      throw Exception('فشل في تحميل المناطق السياحية للولاية: $e');
    }
  }

  // الحصول على المناطق السياحية حسب النوع
  static Future<List<TouristArea>> getTouristAreasByType(String areaType) async {
    try {
      print('🔍 Fetching tourist areas of type: $areaType');
      
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_features(*),
            tourist_area_images(*),
            tourist_area_tips(*)
          ''')
          .eq('area_type', areaType)
          .eq('is_active', true)
          .order('rating', ascending: false);
      
      print('📊 Areas of type $areaType: ${response.length} found');
      
      return response.map((area) => TouristArea.fromJson(area)).toList();
    } catch (e) {
      print('❌ Error fetching tourist areas by type: $e');
      throw Exception('فشل في تحميل المناطق السياحية حسب النوع: $e');
    }
  }

  // الحصول على المناطق السياحية القريبة (بناءً على الإحداثيات)
  static Future<List<TouristArea>> getNearbyTouristAreas({
    required double latitude,
    required double longitude,
    double radiusKm = 50.0,
  }) async {
    try {
      print('🔍 Fetching nearby tourist areas...');
      
      // استعلام بسيط للحصول على جميع المناطق ثم تصفيتها محلياً
      // يمكن تحسين هذا باستخدام PostGIS في المستقبل
      final response = await _supabase
          .from('tourist_areas')
          .select('''
            *,
            tourist_area_features(*),
            tourist_area_images(*),
            tourist_area_tips(*)
          ''')
          .eq('is_active', true)
          .not('latitude', 'is', null)
          .not('longitude', 'is', null);
      
      final areas = response.map((area) => TouristArea.fromJson(area)).toList();
      
      // تصفية المناطق القريبة محلياً
      final nearbyAreas = areas.where((area) {
        if (area.latitude == null || area.longitude == null) return false;
        
        final distance = _calculateDistance(
          latitude,
          longitude,
          area.latitude!,
          area.longitude!,
        );
        
        return distance <= radiusKm;
      }).toList();
      
      // ترتيب حسب المسافة (تقريبي)
      nearbyAreas.sort((a, b) {
        final distanceA = _calculateDistance(latitude, longitude, a.latitude!, a.longitude!);
        final distanceB = _calculateDistance(latitude, longitude, b.latitude!, b.longitude!);
        return distanceA.compareTo(distanceB);
      });
      
      print('📊 Nearby areas: ${nearbyAreas.length} found');
      
      return nearbyAreas;
    } catch (e) {
      print('❌ Error fetching nearby tourist areas: $e');
      throw Exception('فشل في تحميل المناطق السياحية القريبة: $e');
    }
  }

  // حساب المسافة بين نقطتين (بالكيلومتر)
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // نصف قطر الأرض بالكيلومتر
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    
    final double c = 2 * asin(sqrt(a));
    
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  // الحصول على أنواع المناطق السياحية المتاحة
  static Future<List<String>> getAvailableAreaTypes() async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .select('area_type')
          .eq('is_active', true)
          .not('area_type', 'is', null);
      
      final types = response
          .map((item) => item['area_type'] as String)
          .toSet()
          .toList();
      
      return types;
    } catch (e) {
      print('❌ Error fetching area types: $e');
      return [];
    }
  }

  // الحصول على الولايات المتاحة
  static Future<List<String>> getAvailableWilayas() async {
    try {
      final response = await _supabase
          .from('tourist_areas')
          .select('wilaya')
          .eq('is_active', true)
          .not('wilaya', 'is', null);
      
      final wilayas = response
          .map((item) => item['wilaya'] as String)
          .toSet()
          .toList();
      
      return wilayas;
    } catch (e) {
      print('❌ Error fetching wilayas: $e');
      return [];
    }
  }
}