import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hotel_model.dart';

class HotelService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all active hotels
  Future<List<Hotel>> getAllHotels() async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('*')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => Hotel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب الفنادق: $e');
    }
  }

  // Get hotels by wilaya
  Future<List<Hotel>> getHotelsByWilaya(String wilaya) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('*')
          .eq('is_active', true)
          .eq('wilaya', wilaya)
          .order('rating', ascending: false);

      return (response as List)
          .map((item) => Hotel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب فنادق $wilaya: $e');
    }
  }

  // Get hotels by city
  Future<List<Hotel>> getHotelsByCity(String city) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('*')
          .eq('is_active', true)
          .eq('city', city)
          .order('rating', ascending: false);

      return (response as List)
          .map((item) => Hotel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب فنادق $city: $e');
    }
  }

  // Get hotel by ID with all related data
  Future<Hotel?> getHotelById(String hotelId) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('''
            *,
            room_types(*),
            hotel_amenities(*),
            hotel_images(*),
            hotel_policies(*)
          ''')
          .eq('id', hotelId)
          .eq('is_active', true)
          .single();

      return Hotel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Search hotels by name
  Future<List<Hotel>> searchHotels(String query) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('*')
          .eq('is_active', true)
          // TODO: Fix search functionality
           // .textSearch('name', query)
          .order('rating', ascending: false);

      return (response as List)
          .map((item) => Hotel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في البحث عن الفنادق: $e');
    }
  }

  // Get hotels by star rating
  Future<List<Hotel>> getHotelsByStarRating(int starRating) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('*')
          .eq('is_active', true)
          .eq('star_rating', starRating)
          .order('rating', ascending: false);

      return (response as List)
          .map((item) => Hotel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب الفنادق بتصنيف $starRating نجوم: $e');
    }
  }

  // Get hotels by price range
  Future<List<Hotel>> getHotelsByPriceRange(double minPrice, double maxPrice) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('''
            *,
            room_types!inner(*)
          ''')
          .eq('is_active', true)
          .gte('room_types.price_per_night', minPrice)
          .lte('room_types.price_per_night', maxPrice)
          .order('rating', ascending: false);

      return (response as List)
          .map((item) => Hotel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب الفنادق بالنطاق السعري المحدد: $e');
    }
  }

  // Get top rated hotels
  Future<List<Hotel>> getTopRatedHotels({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('*')
          .eq('is_active', true)
          .gte('rating', 4.0)
          .order('rating', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => Hotel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب أفضل الفنادق: $e');
    }
  }

  // Get available wilayas
  Future<List<String>> getAvailableWilayas() async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('wilaya')
          .eq('is_active', true)
          .not('wilaya', 'is', null);

      final wilayas = (response as List)
          .map((item) => item['wilaya'] as String?)
          .where((wilaya) => wilaya != null)
          .cast<String>()
          .toSet()
          .toList();

      wilayas.sort();
      return wilayas;
    } catch (e) {
      throw Exception('فشل في جلب قائمة الولايات: $e');
    }
  }

  // Get available cities by wilaya
  Future<List<String>> getCitiesByWilaya(String wilaya) async {
    try {
      final response = await _supabase
          .from('hotels')
          .select('city')
          .eq('is_active', true)
          .eq('wilaya', wilaya)
          .not('city', 'is', null);

      final cities = (response as List)
          .map((item) => item['city'] as String?)
          .where((city) => city != null)
          .cast<String>()
          .toSet()
          .toList();

      cities.sort();
      return cities;
    } catch (e) {
      throw Exception('فشل في جلب قائمة المدن: $e');
    }
  }

  // Get room types for a hotel
  Future<List<RoomType>> getRoomTypesByHotel(String hotelId) async {
    try {
      final response = await _supabase
          .from('room_types')
          .select('*')
          .eq('hotel_id', hotelId)
          .eq('is_active', true)
          .order('price_per_night', ascending: true);

      return (response as List)
          .map((item) => RoomType.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب أنواع الغرف: $e');
    }
  }

  // Get hotel amenities
  Future<List<HotelAmenity>> getHotelAmenities(String hotelId) async {
    try {
      final response = await _supabase
          .from('hotel_amenities')
          .select('*')
          .eq('hotel_id', hotelId)
          .order('amenity_name', ascending: true);

      return (response as List)
          .map((item) => HotelAmenity.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب مرافق الفندق: $e');
    }
  }

  // Get hotel images
  Future<List<HotelImage>> getHotelImages(String hotelId) async {
    try {
      final response = await _supabase
          .from('hotel_images')
          .select('*')
          .eq('hotel_id', hotelId)
          .order('display_order', ascending: true);

      return (response as List)
          .map((item) => HotelImage.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب صور الفندق: $e');
    }
  }

  // Get hotel policies
  Future<List<HotelPolicy>> getHotelPolicies(String hotelId) async {
    try {
      final response = await _supabase
          .from('hotel_policies')
          .select('*')
          .eq('hotel_id', hotelId)
          .eq('is_active', true)
          .order('policy_type', ascending: true);

      return (response as List)
          .map((item) => HotelPolicy.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب سياسات الفندق: $e');
    }
  }

  // Admin functions
  
  // Add new hotel
  Future<Hotel> addHotel(Hotel hotel) async {
    try {
      final response = await _supabase
          .from('hotels')
          .insert(hotel.toInsertJson())
          .select()
          .single();

      return Hotel.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة الفندق: $e');
    }
  }

  // Update hotel
  Future<Hotel> updateHotel(String hotelId, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from('hotels')
          .update(updates)
          .eq('id', hotelId)
          .select()
          .single();

      return Hotel.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحديث الفندق: $e');
    }
  }

  // Delete hotel (soft delete)
  Future<void> deleteHotel(String hotelId) async {
    try {
      await _supabase
          .from('hotels')
          .update({'is_active': false})
          .eq('id', hotelId);
    } catch (e) {
      throw Exception('فشل في حذف الفندق: $e');
    }
  }

  // Add room type
  Future<RoomType> addRoomType(RoomType roomType) async {
    try {
      final response = await _supabase
          .from('room_types')
          .insert(roomType.toJson())
          .select()
          .single();

      return RoomType.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة نوع الغرفة: $e');
    }
  }

  // Add hotel amenity
  Future<HotelAmenity> addHotelAmenity(HotelAmenity amenity) async {
    try {
      final response = await _supabase
          .from('hotel_amenities')
          .insert(amenity.toJson())
          .select()
          .single();

      return HotelAmenity.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة مرفق الفندق: $e');
    }
  }

  // Add hotel image
  Future<HotelImage> addHotelImage(HotelImage image) async {
    try {
      final response = await _supabase
          .from('hotel_images')
          .insert(image.toJson())
          .select()
          .single();

      return HotelImage.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة صورة الفندق: $e');
    }
  }

  // Add hotel policy
  Future<HotelPolicy> addHotelPolicy(HotelPolicy policy) async {
    try {
      final response = await _supabase
          .from('hotel_policies')
          .insert(policy.toJson())
          .select()
          .single();

      return HotelPolicy.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة سياسة الفندق: $e');
    }
  }

  // Get hotel statistics
  Future<Map<String, dynamic>> getHotelStatistics() async {
    try {
      final totalHotelsResponse = await _supabase
          .from('hotels')
          .select('id')
          .eq('is_active', true);

      final avgRating = await _supabase
          .rpc('get_average_hotel_rating');

      final topWilaya = await _supabase
          .rpc('get_top_hotel_wilaya');

      return {
        'total_hotels': totalHotelsResponse.length,
        'average_rating': avgRating ?? 0.0,
        'top_wilaya': topWilaya ?? 'غير محدد',
      };
    } catch (e) {
      return {
        'total_hotels': 0,
        'average_rating': 0.0,
        'top_wilaya': 'غير محدد',
      };
    }
  }
}