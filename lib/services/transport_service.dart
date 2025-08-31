import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transport_company_model.dart';

class TransportService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // جلب جميع شركات النقل النشطة
  Future<List<TransportCompany>> getAllTransportCompanies() async {
    try {
      final response = await _supabase
          .from('transport_companies')
          .select('*')
          .eq('is_active', true)
          .order('name');

      return (response as List)
          .map((company) => TransportCompany.fromJson(company))
          .toList();
    } catch (e) {
      print('خطأ في جلب شركات النقل: $e');
      throw Exception('فشل في جلب شركات النقل');
    }
  }

  // جلب شركات النقل حسب النوع
  Future<List<TransportCompany>> getTransportCompaniesByType(String transportType) async {
    try {
      final response = await _supabase
          .from('transport_companies')
          .select('*')
          .eq('is_active', true)
          .eq('transport_type', transportType)
          .order('name');

      return (response as List)
          .map((company) => TransportCompany.fromJson(company))
          .toList();
    } catch (e) {
      print('خطأ في جلب شركات النقل حسب النوع: $e');
      throw Exception('فشل في جلب شركات النقل');
    }
  }

  // البحث في شركات النقل
  Future<List<TransportCompany>> searchTransportCompanies(String query) async {
    try {
      final response = await _supabase
          .from('transport_companies')
          .select('*')
          .eq('is_active', true)
          // TODO: Fix search functionality
          // .textSearch('name,description', query)
          .order('name');

      return (response as List)
          .map((company) => TransportCompany.fromJson(company))
          .toList();
    } catch (e) {
      print('خطأ في البحث عن شركات النقل: $e');
      throw Exception('فشل في البحث عن شركات النقل');
    }
  }

  // جلب تفاصيل شركة نقل واحدة مع الطرق والجداول
  Future<TransportCompany?> getTransportCompanyDetails(String companyId) async {
    try {
      final response = await _supabase
          .from('transport_companies')
          .select('''
            *,
            routes:transport_routes(
              *,
              schedules:transport_schedules(*)
            ),
            images:transport_company_images(*)
          ''')
          .eq('id', companyId)
          .eq('is_active', true)
          .single();

      return TransportCompany.fromJson(response);
    } catch (e) {
      print('خطأ في جلب تفاصيل شركة النقل: $e');
      return null;
    }
  }

  // جلب الطرق لشركة معينة
  Future<List<TransportRoute>> getRoutesByCompany(String companyId) async {
    try {
      final response = await _supabase
          .from('transport_routes')
          .select('''
            *,
            schedules:transport_schedules(*)
          ''')
          .eq('company_id', companyId)
          .eq('is_active', true)
          .order('route_name');

      return (response as List)
          .map((route) => TransportRoute.fromJson(route))
          .toList();
    } catch (e) {
      print('خطأ في جلب طرق الشركة: $e');
      throw Exception('فشل في جلب طرق الشركة');
    }
  }

  // البحث عن طرق بين مدينتين
  Future<List<TransportRoute>> searchRoutes(String origin, String destination) async {
    try {
      final response = await _supabase
          .from('transport_routes')
          .select('''
            *,
            company:transport_companies(*),
            schedules:transport_schedules(*)
          ''')
          .eq('is_active', true)
          // TODO: Fix search functionality
          // .textSearch('origin', origin)
          // .textSearch('destination', destination)
          .order('price');

      return (response as List)
          .map((route) => TransportRoute.fromJson(route))
          .toList();
    } catch (e) {
      print('خطأ في البحث عن الطرق: $e');
      throw Exception('فشل في البحث عن الطرق');
    }
  }

  // جلب صور شركة النقل
  Future<List<TransportCompanyImage>> getCompanyImages(String companyId) async {
    try {
      final response = await _supabase
          .from('transport_company_images')
          .select('*')
          .eq('company_id', companyId)
          .order('display_order');

      return (response as List)
          .map((image) => TransportCompanyImage.fromJson(image))
          .toList();
    } catch (e) {
      print('خطأ في جلب صور الشركة: $e');
      throw Exception('فشل في جلب صور الشركة');
    }
  }

  // إضافة شركة نقل جديدة (للمالكين والإداريين)
  Future<TransportCompany?> addTransportCompany({
    required String name,
    String? phone,
    String? transportType,
    String? description,
    String? coverImage,
    String? priceRange,
  }) async {
    try {
      final response = await _supabase
          .from('transport_companies')
          .insert({
            'name': name,
            'phone': phone,
            'transport_type': transportType,
            'description': description,
            'cover_image': coverImage,
            'price_range': priceRange,
          })
          .select()
          .single();

      return TransportCompany.fromJson(response);
    } catch (e) {
      print('خطأ في إضافة شركة النقل: $e');
      throw Exception('فشل في إضافة شركة النقل');
    }
  }

  // تحديث شركة النقل
  Future<TransportCompany?> updateTransportCompany(
    String companyId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _supabase
          .from('transport_companies')
          .update(updates)
          .eq('id', companyId)
          .select()
          .single();

      return TransportCompany.fromJson(response);
    } catch (e) {
      print('خطأ في تحديث شركة النقل: $e');
      throw Exception('فشل في تحديث شركة النقل');
    }
  }

  // حذف شركة النقل (إلغاء تفعيل)
  Future<bool> deactivateTransportCompany(String companyId) async {
    try {
      await _supabase
          .from('transport_companies')
          .update({'is_active': false})
          .eq('id', companyId);

      return true;
    } catch (e) {
      print('خطأ في إلغاء تفعيل شركة النقل: $e');
      return false;
    }
  }

  // إضافة طريق جديد
  Future<TransportRoute?> addRoute({
    required String companyId,
    required String routeName,
    required String origin,
    required String destination,
    double? distanceKm,
    int? estimatedDurationMinutes,
    double? price,
  }) async {
    try {
      final response = await _supabase
          .from('transport_routes')
          .insert({
            'company_id': companyId,
            'route_name': routeName,
            'origin': origin,
            'destination': destination,
            'distance_km': distanceKm,
            'estimated_duration_minutes': estimatedDurationMinutes,
            'price': price,
          })
          .select()
          .single();

      return TransportRoute.fromJson(response);
    } catch (e) {
      print('خطأ في إضافة الطريق: $e');
      throw Exception('فشل في إضافة الطريق');
    }
  }

  // إضافة جدول زمني
  Future<TransportSchedule?> addSchedule({
    required String routeId,
    required String departureTime,
    String? arrivalTime,
    List<int>? daysOfWeek,
  }) async {
    try {
      final response = await _supabase
          .from('transport_schedules')
          .insert({
            'route_id': routeId,
            'departure_time': departureTime,
            'arrival_time': arrivalTime,
            'days_of_week': daysOfWeek ?? [1, 2, 3, 4, 5, 6, 7],
          })
          .select()
          .single();

      return TransportSchedule.fromJson(response);
    } catch (e) {
      print('خطأ في إضافة الجدول الزمني: $e');
      throw Exception('فشل في إضافة الجدول الزمني');
    }
  }

  // إضافة صورة للشركة
  Future<TransportCompanyImage?> addCompanyImage({
    required String companyId,
    required String imageUrl,
    String? altText,
    int displayOrder = 0,
  }) async {
    try {
      final response = await _supabase
          .from('transport_company_images')
          .insert({
            'company_id': companyId,
            'image_url': imageUrl,
            'alt_text': altText,
            'display_order': displayOrder,
          })
          .select()
          .single();

      return TransportCompanyImage.fromJson(response);
    } catch (e) {
      print('خطأ في إضافة صورة الشركة: $e');
      throw Exception('فشل في إضافة صورة الشركة');
    }
  }
}