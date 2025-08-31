import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_trip_request_model.dart';

class AiTripService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _apiKey = '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';
  static const String _model = 'moonshotai/kimi-k2:free';

  static Future<AiTripResponse> generateTripPlan(AiTripRequest request) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };

      final body = {
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': request.generatePrompt(),
          }
        ],
        'max_tokens': 4000,
        'temperature': 0.7,
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['choices'] != null && 
            responseData['choices'].isNotEmpty &&
            responseData['choices'][0]['message'] != null) {
          
          final content = responseData['choices'][0]['message']['content'] as String;
          return AiTripResponse.success(content);
        } else {
          return AiTripResponse.error('لم يتم الحصول على رد صحيح من الخدمة');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'خطأ في الاتصال بالخدمة';
        return AiTripResponse.error('خطأ ${response.statusCode}: $errorMessage');
      }
    } catch (e) {
      return AiTripResponse.error('خطأ في الاتصال: ${e.toString()}');
    }
  }

  // قائمة الولايات الجزائرية منظمة حسب المناطق
  static Map<String, List<String>> getAlgerianWilayasByRegion() {
    return {
      'الشمال': ['الجزائر', 'وهران', 'عنابة', 'قسنطينة', 'البليدة', 'تيزي وزو', 'بومرداس', 'تيبازة', 'جيجل', 'سكيكدة', 'الطارف'],
      'الوسط': ['سطيف', 'برج بوعريريج', 'المسيلة', 'البويرة', 'المدية', 'تيارت', 'تيسمسيلت', 'عين الدفلى', 'الشلف', 'غليزان'],
      'الغرب': ['تلمسان', 'سيدي بلعباس', 'مستغانم', 'معسكر', 'سعيدة', 'النعامة', 'عين تموشنت', 'البيض'],
      'الشرق': ['باتنة', 'خنشلة', 'أم البواقي', 'تبسة', 'سوق أهراس', 'قالمة', 'ميلة'],
      'الجنوب': ['ورقلة', 'غرداية', 'الأغواط', 'الجلفة', 'بسكرة', 'الوادي', 'تقرت'],
      'الصحراء الكبرى': ['تمنراست', 'أدرار', 'إليزي', 'تندوف', 'بشار', 'تيميمون', 'برج باجي مختار', 'أولاد جلال', 'بني عباس', 'إن صالح', 'إن قزام', 'جانت', 'المغير', 'المنيعة'],
    };
  }

  // قائمة الولايات الجزائرية (للتوافق مع الكود الموجود)
  static List<String> getAlgerianWilayas() {
    final regions = getAlgerianWilayasByRegion();
    List<String> allWilayas = [];
    regions.values.forEach((wilayas) => allWilayas.addAll(wilayas));
    return allWilayas;
  }

  // قائمة التفضيلات السياحية مع الأيقونات
  static Map<String, String> getTravelPreferencesWithIcons() {
    return {
      'الصحراء': '🏜️',
      'البحر والشواطئ': '🏖️',
      'الجبال والطبيعة': '🏔️',
      'المواقع التاريخية': '🏛️',
      'المواقع الأثرية': '🗿',
      'الثقافة والتراث': '🎭',
      'المدن العصرية': '🏙️',
      'الريف والقرى': '🏘️',
      'الحمامات المعدنية': '♨️',
      'المتاحف والفنون': '🎨',
    };
  }

  // قائمة التفضيلات السياحية (للتوافق مع الكود الموجود)
  static List<String> getTravelPreferences() {
    return getTravelPreferencesWithIcons().keys.toList();
  }

  // قائمة الاهتمامات مع الأيقونات
  static Map<String, String> getTravelInterestsWithIcons() {
    return {
      'الطبيعة والمناظر': '🌿',
      'التاريخ والآثار': '🏺',
      'الثقافة المحلية': '🎪',
      'المغامرة والرياضة': '🧗',
      'الاسترخاء والراحة': '🧘',
      'التصوير الفوتوغرافي': '📸',
      'الطعام المحلي': '🍽️',
      'التسوق والحرف': '🛍️',
      'الحياة الليلية': '🌃',
      'الأنشطة العائلية': '👨‍👩‍👧‍👦',
    };
  }

  // قائمة الاهتمامات (للتوافق مع الكود الموجود)
  static List<String> getTravelInterests() {
    return getTravelInterestsWithIcons().keys.toList();
  }

  // أنماط السفر
  static List<String> getTravelStyles() {
    return [
      'اقتصادي',
      'متوسط',
      'فاخر',
    ];
  }
}