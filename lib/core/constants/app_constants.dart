import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Muted Palette
  static const Color primary = Color(0xFF6B7280); // Muted gray
  static const Color secondary = Color(0xFF9CA3AF); // Light gray
  static const Color accent = Color(0xFF10B981); // Muted green
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color border = Color(0xFFE5E7EB);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
}

class AppSpacing {
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
  static const double xxLarge = 48.0;
}

class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 24.0;
}

class AppFontSizes {
  static const double extraSmall = 12.0;
  static const double small = 14.0;
  static const double medium = 16.0;
  static const double large = 18.0;
  static const double extraLarge = 24.0;
  static const double xxLarge = 32.0;
}

class AppFonts {
  static const String amiri = 'Amiri'; // للنصوص العربية الكلاسيكية
  static const String tajawal = 'Tajawal'; // لواجهات بسيطة وعصرية
}

class AppStrings {
  // App General
  static const String appName = 'بوابة الجزائر';
  static const String welcome = 'مرحباً بك';
  static const String getStarted = 'ابدأ الآن';
  static const String next = 'التالي';
  static const String skip = 'تخطي';
  static const String done = 'تم';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String save = 'حفظ';
  static const String edit = 'تعديل';
  static const String delete = 'حذف';
  static const String search = 'بحث';
  static const String filter = 'تصفية';
  static const String loading = 'جاري التحميل...';
  static const String error = 'خطأ';
  static const String success = 'نجح';
  static const String retry = 'إعادة المحاولة';
  
  // Onboarding
  static const String onboardingTitle1 = 'اكتشف المطاعم';
  static const String onboardingDesc1 = 'اعثر على أفضل المطاعم والمقاهي في منطقتك';
  
  static const String onboardingTitle2 = 'خدمات التوصيل';
  static const String onboardingDesc2 = 'احصل على طلباتك بسرعة وأمان إلى باب منزلك';
  
  static const String onboardingTitle3 = 'حجز الفنادق';
  static const String onboardingDesc3 = 'احجز إقامتك المثالية بأفضل الأسعار';
  
  static const String onboardingTitle4 = 'وسائل النقل';
  static const String onboardingDesc4 = 'تنقل بسهولة مع خدمات النقل المتنوعة';
  
  static const String onboardingTitle5 = 'السفر والسياحة';
  static const String onboardingDesc5 = 'خطط لرحلتك القادمة مع أفضل وكالات السفر';
  
  // Authentication
  static const String login = 'تسجيل الدخول';
  static const String signUp = 'إنشاء حساب';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String resetPassword = 'إعادة تعيين كلمة المرور';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String fullName = 'الاسم الكامل';
  static const String phoneNumber = 'رقم الهاتف';
  static const String rememberMe = 'تذكرني';
  static const String dontHaveAccount = 'ليس لديك حساب؟';
  static const String alreadyHaveAccount = 'لديك حساب بالفعل؟';
  static const String createAccount = 'إنشاء حساب جديد';
  static const String loginToAccount = 'تسجيل الدخول';
  
  // Categories
  static const String restaurants = 'المطاعم';
  static const String hotels = 'الفنادق';
  static const String transport = 'النقل';
  static const String delivery = 'التوصيل';
  static const String travel = 'السفر';
  static const String tourism = 'السياحة';
  
  // Validation Messages
  static const String fieldRequired = 'هذا الحقل مطلوب';
  static const String invalidEmail = 'البريد الإلكتروني غير صحيح';
  static const String passwordTooShort = 'كلمة المرور قصيرة جداً';
  static const String passwordsNotMatch = 'كلمات المرور غير متطابقة';
  static const String invalidPhoneNumber = 'رقم الهاتف غير صحيح';
}

class AppImages {
  // Welcome Pages
  static const String welcomeTransport = 'assets/images/weclome_pages/Transport.gif';
  static const String welcomeDelivery = 'assets/images/weclome_pages/delivery.gif';
  static const String welcomeHotel = 'assets/images/weclome_pages/hotel.gif';
  static const String welcomeRestaurant = 'assets/images/weclome_pages/restaurant.gif';
  static const String welcomeTravel = 'assets/images/weclome_pages/travel.gif';
  
  // Auth Pages
  static const String authLogin = 'assets/images/auth/login.gif';
  static const String authSignUp = 'assets/images/auth/sign-up.gif';
  static const String authPassword = 'assets/images/auth/password.gif';
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signUp = '/signup'; // Alias for backward compatibility
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
}