import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_constants.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/screens/auth/forgot_password_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/hotels/hotels_screen.dart';
import 'presentation/screens/transport_companies_screen.dart';
import 'presentation/screens/delivery_companies_screen.dart';
import 'presentation/screens/travel_agencies/travel_agencies_screen.dart';
import 'presentation/screens/tourist_areas/tourist_areas_screen.dart';
import 'presentation/screens/ai_trip/ai_trip_screen.dart';
import 'presentation/screens/favorites_screen.dart';
import 'presentation/screens/restaurants_screen.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initialize();
  await StorageService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      
      // RTL Support
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // Arabic
        Locale('en', 'US'), // English
      ],
      locale: const Locale('ar', 'SA'),
      
      // Theme Configuration
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.tajawalTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.amiri(),
          displayMedium: GoogleFonts.amiri(),
          displaySmall: GoogleFonts.amiri(),
          headlineLarge: GoogleFonts.amiri(),
          headlineMedium: GoogleFonts.amiri(),
          headlineSmall: GoogleFonts.amiri(),
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.large,
              vertical: AppSpacing.medium,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            borderSide: BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.all(AppSpacing.medium),
        ),
      ),
      
      // Router Configuration
      routerConfig: _router,
    );
  }
}

// GoRouter Configuration with Custom Page Transitions
final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const LoginScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.signup,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const SignUpScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const ProfileScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.favorites,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const FavoritesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.restaurants,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const RestaurantsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.hotels,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const HotelsScreen(),
      ),
    ),
    GoRoute(
      path: '${AppRoutes.hotelDetail}/:id',
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        HotelDetailScreen(hotelId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.transportCompanies,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const TransportCompaniesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.deliveryCompanies,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const DeliveryCompaniesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.travelAgencies,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const TravelAgenciesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.touristAreas,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const TouristAreasScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.aiTrip,
      pageBuilder: (context, state) => _buildPageWithTransition(
        context,
        state,
        const AiTripScreen(),
      ),
    ),
  ],
);

// Custom Page Transition Builder
Page<dynamic> _buildPageWithTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide transition from right to left
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      var slideAnimation = animation.drive(tween);

      // Fade transition
      var fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ));

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}
