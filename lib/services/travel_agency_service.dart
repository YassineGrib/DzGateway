import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/travel_agency_model.dart';

class TravelAgencyService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all active travel agencies
  Future<List<TravelAgency>> getAllTravelAgencies() async {
    try {
      print('Querying travel agencies from Supabase...');
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_offers(*),
            destinations(*),
            travel_agency_images(*)
          ''')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      print('Raw response from Supabase: $response');
      print('Response type: ${response.runtimeType}');
      print('Response length: ${(response as List).length}');

      return (response as List)
          .map((agency) => TravelAgency.fromJson(agency))
          .toList();
    } catch (e) {
      print('Error in getAllTravelAgencies: $e');
      throw Exception('فشل في جلب الوكالات السياحية: $e');
    }
  }

  // Get travel agency by ID
  Future<TravelAgency?> getTravelAgencyById(String id) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_offers(*),
            destinations(*),
            travel_agency_images(*)
          ''')
          .eq('id', id)
          .eq('is_active', true)
          .single();

      return TravelAgency.fromJson(response);
    } catch (e) {
      throw Exception('فشل في جلب بيانات الوكالة السياحية: $e');
    }
  }

  // Search travel agencies by name
  Future<List<TravelAgency>> searchTravelAgencies(String query) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_offers(*),
            destinations(*),
            travel_agency_images(*)
          ''')
          .eq('is_active', true)
          .ilike('name', '%$query%')
          .order('rating', ascending: false);

      return (response as List)
          .map((agency) => TravelAgency.fromJson(agency))
          .toList();
    } catch (e) {
      throw Exception('فشل في البحث عن الوكالات السياحية: $e');
    }
  }

  // Get top rated travel agencies
  Future<List<TravelAgency>> getTopRatedTravelAgencies({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_offers(*),
            destinations(*),
            travel_agency_images(*)
          ''')
          .eq('is_active', true)
          .gte('rating', 4.0)
          .order('rating', ascending: false)
          .order('total_reviews', ascending: false)
          .limit(limit);

      return (response as List)
          .map((agency) => TravelAgency.fromJson(agency))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب الوكالات السياحية الأعلى تقييماً: $e');
    }
  }

  // Get travel agencies by price range
  Future<List<TravelAgency>> getTravelAgenciesByPriceRange(String priceRange) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('''
            *,
            travel_offers(*),
            destinations(*),
            travel_agency_images(*)
          ''')
          .eq('is_active', true)
          .eq('price_range', priceRange)
          .order('rating', ascending: false);

      return (response as List)
          .map((agency) => TravelAgency.fromJson(agency))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب الوكالات السياحية بالنطاق السعري المحدد: $e');
    }
  }

  // Get travel offers for a specific agency
  Future<List<TravelOffer>> getTravelOffers(String agencyId) async {
    try {
      final response = await _supabase
          .from('travel_offers')
          .select()
          .eq('agency_id', agencyId)
          .eq('is_available', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((offer) => TravelOffer.fromJson(offer))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب عروض السفر: $e');
    }
  }

  // Get destinations for a specific agency
  Future<List<Destination>> getDestinations(String agencyId) async {
    try {
      final response = await _supabase
          .from('destinations')
          .select()
          .eq('agency_id', agencyId)
          .order('name');

      return (response as List)
          .map((dest) => Destination.fromJson(dest))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب الوجهات السياحية: $e');
    }
  }

  // Get destinations by type (domestic/international)
  Future<List<Destination>> getDestinationsByType(String destinationType) async {
    try {
      final response = await _supabase
          .from('destinations')
          .select('''
            *,
            travel_agencies!inner(*)
          ''')
          .eq('destination_type', destinationType)
          .eq('travel_agencies.is_active', true)
          .order('name');

      return (response as List)
          .map((dest) => Destination.fromJson(dest))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب الوجهات السياحية: $e');
    }
  }

  // Get travel offers by type
  Future<List<TravelOffer>> getTravelOffersByType(String offerType) async {
    try {
      final response = await _supabase
          .from('travel_offers')
          .select('''
            *,
            travel_agencies!inner(*)
          ''')
          .eq('offer_type', offerType)
          .eq('is_available', true)
          .eq('travel_agencies.is_active', true)
          .order('price');

      return (response as List)
          .map((offer) => TravelOffer.fromJson(offer))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب عروض السفر: $e');
    }
  }

  // Get available offer types
  Future<List<String>> getAvailableOfferTypes() async {
    try {
      final response = await _supabase
          .from('travel_offers')
          .select('offer_type')
          .eq('is_available', true)
          .not('offer_type', 'is', null);

      final offerTypes = (response as List)
          .map((item) => item['offer_type'] as String?)
          .where((type) => type != null)
          .cast<String>()
          .toSet()
          .toList();

      offerTypes.sort();
      return offerTypes;
    } catch (e) {
      throw Exception('فشل في جلب أنواع العروض: $e');
    }
  }

  // Get available price ranges
  Future<List<String>> getAvailablePriceRanges() async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .select('price_range')
          .eq('is_active', true)
          .not('price_range', 'is', null);

      final priceRanges = (response as List)
          .map((item) => item['price_range'] as String?)
          .where((range) => range != null)
          .cast<String>()
          .toSet()
          .toList();

      priceRanges.sort();
      return priceRanges;
    } catch (e) {
      throw Exception('فشل في جلب النطاقات السعرية: $e');
    }
  }

  // Create a new travel agency (for agency owners)
  Future<TravelAgency> createTravelAgency(TravelAgency agency) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .insert(agency.toJson())
          .select()
          .single();

      return TravelAgency.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إنشاء الوكالة السياحية: $e');
    }
  }

  // Update travel agency
  Future<TravelAgency> updateTravelAgency(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from('travel_agencies')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return TravelAgency.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحديث الوكالة السياحية: $e');
    }
  }

  // Delete travel agency (soft delete by setting is_active to false)
  Future<void> deleteTravelAgency(String id) async {
    try {
      await _supabase
          .from('travel_agencies')
          .update({'is_active': false})
          .eq('id', id);
    } catch (e) {
      throw Exception('فشل في حذف الوكالة السياحية: $e');
    }
  }

  // Create a new travel offer
  Future<TravelOffer> createTravelOffer(TravelOffer offer) async {
    try {
      final response = await _supabase
          .from('travel_offers')
          .insert(offer.toJson())
          .select()
          .single();

      return TravelOffer.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إنشاء عرض السفر: $e');
    }
  }

  // Update travel offer
  Future<TravelOffer> updateTravelOffer(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from('travel_offers')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return TravelOffer.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحديث عرض السفر: $e');
    }
  }

  // Delete travel offer (soft delete by setting is_available to false)
  Future<void> deleteTravelOffer(String id) async {
    try {
      await _supabase
          .from('travel_offers')
          .update({'is_available': false})
          .eq('id', id);
    } catch (e) {
      throw Exception('فشل في حذف عرض السفر: $e');
    }
  }

  // Create a new destination
  Future<Destination> createDestination(Destination destination) async {
    try {
      final response = await _supabase
          .from('destinations')
          .insert(destination.toJson())
          .select()
          .single();

      return Destination.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إنشاء الوجهة السياحية: $e');
    }
  }

  // Update destination
  Future<Destination> updateDestination(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from('destinations')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return Destination.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحديث الوجهة السياحية: $e');
    }
  }

  // Delete destination
  Future<void> deleteDestination(String id) async {
    try {
      await _supabase
          .from('destinations')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('فشل في حذف الوجهة السياحية: $e');
    }
  }

  // Add image to travel agency
  Future<TravelAgencyImage> addTravelAgencyImage(TravelAgencyImage image) async {
    try {
      final response = await _supabase
          .from('travel_agency_images')
          .insert(image.toJson())
          .select()
          .single();

      return TravelAgencyImage.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة صورة للوكالة السياحية: $e');
    }
  }

  // Delete travel agency image
  Future<void> deleteTravelAgencyImage(String id) async {
    try {
      await _supabase
          .from('travel_agency_images')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('فشل في حذف صورة الوكالة السياحية: $e');
    }
  }
}