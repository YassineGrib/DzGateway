import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/travel_agency_model.dart';

class TravelService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all active travel agencies
  Future<List<TravelAgency>> getAllTravelAgencies() async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_agency_images(*)
          ''')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((agency) => TravelAgency.fromJson(agency))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب وكالات السفر: $e');
    }
  }

  // Get travel agency by ID
  Future<TravelAgency?> getTravelAgencyById(String agencyId) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_agency_images(*)
          ''')
          .eq('id', agencyId)
          .eq('is_active', true)
          .single();

      return TravelAgency.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Search travel agencies
  Future<List<TravelAgency>> searchTravelAgencies(String query) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_agency_images(*)
          ''')
          .eq('is_active', true)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('rating', ascending: false);

      return (response as List)
          .map((agency) => TravelAgency.fromJson(agency))
          .toList();
    } catch (e) {
      throw Exception('فشل في البحث عن وكالات السفر: $e');
    }
  }

  // Get travel agencies by wilaya
  Future<List<TravelAgency>> getTravelAgenciesByWilaya(String wilaya) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_agency_images(*)
          ''')
          .eq('is_active', true)
          .eq('wilaya', wilaya)
          .order('rating', ascending: false);

      return (response as List)
          .map((agency) => TravelAgency.fromJson(agency))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب وكالات السفر في $wilaya: $e');
    }
  }

  // Get top rated travel agencies
  Future<List<TravelAgency>> getTopRatedTravelAgencies({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_agency_images(*)
          ''')
          .eq('is_active', true)
          .gte('rating', 4.0)
          .order('rating', ascending: false)
          .limit(limit);

      return (response as List)
          .map((agency) => TravelAgency.fromJson(agency))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب أفضل وكالات السفر: $e');
    }
  }

  // Create travel agency (Admin only)
  Future<TravelAgency?> createTravelAgency(Map<String, dynamic> agencyData) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .insert(agencyData)
          .select()
          .single();

      return TravelAgency.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إنشاء وكالة السفر: $e');
    }
  }

  // Update travel agency (Admin only)
  Future<TravelAgency?> updateTravelAgency(String agencyId, Map<String, dynamic> agencyData) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .update(agencyData)
          .eq('id', agencyId)
          .select()
          .single();

      return TravelAgency.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحديث وكالة السفر: $e');
    }
  }

  // Delete travel agency (Admin only)
  Future<bool> deleteTravelAgency(String agencyId) async {
    try {
      await _supabase
          .from('travel_agencies')
          .update({'is_active': false})
          .eq('id', agencyId);
      return true;
    } catch (e) {
      throw Exception('فشل في حذف وكالة السفر: $e');
    }
  }

  // Get travel agency statistics
  Future<Map<String, dynamic>> getTravelAgencyStatistics() async {
    try {
      final totalAgenciesResponse = await _supabase
          .from('travel_agencies')
          .select('id')
          .eq('is_active', true);

      final avgRating = await _supabase
          .rpc('get_average_travel_agency_rating');

      final topWilaya = await _supabase
          .rpc('get_top_travel_agency_wilaya');

      return {
        'total_agencies': totalAgenciesResponse.length,
        'average_rating': avgRating ?? 0.0,
        'top_wilaya': topWilaya ?? 'غير محدد',
      };
    } catch (e) {
      return {
        'total_agencies': 0,
        'average_rating': 0.0,
        'top_wilaya': 'غير محدد',
      };
    }
  }
}