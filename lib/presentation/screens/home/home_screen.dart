import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../restaurants_screen.dart';
import '../delivery_companies_screen.dart';
import '../../../services/restaurant_service.dart';
import '../../../services/hotel_service.dart';
import '../../../services/transport_service.dart';
import '../../../services/delivery_service.dart';
import '../../../services/travel_agency_service.dart';
import '../../../services/tourist_area_service.dart';
import '../../../models/restaurant_model.dart';
import '../../../models/hotel_model.dart';
import '../../../models/transport_company_model.dart';
import '../../../models/delivery_company_model.dart';
import '../../../models/travel_agency_model.dart';
import '../../../models/tourist_area_model.dart';
import '../ai_trip/ai_trip_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final RestaurantService _restaurantService = RestaurantService();
  final HotelService _hotelService = HotelService();
  final TransportService _transportService = TransportService();
  final DeliveryService _deliveryService = DeliveryService();
  final TravelAgencyService _travelAgencyService = TravelAgencyService();
  final TouristAreaService _touristAreaService = TouristAreaService();
  
  List<Restaurant> _featuredRestaurants = [];
  List<Hotel> _featuredHotels = [];
  List<TransportCompany> _featuredTransport = [];
  List<DeliveryCompany> _featuredDelivery = [];
  List<TravelAgency> _featuredTravelAgencies = [];
  List<TouristArea> _featuredTouristAreas = [];
  bool _isLoading = true;
  

  final String _welcomeText = 'اكتشف أفضل الخدمات والمرافق في جميع أنحاء الجزائر';

  @override
  void initState() {
    super.initState();
    _loadFeaturedServices();
  }

  Future<void> _loadFeaturedServices() async {
    try {
      // تحميل خدمة واحدة من كل فئة
      final restaurants = await _restaurantService.getTopRatedRestaurants(limit: 1);
      final hotels = await _hotelService.getTopRatedHotels(limit: 1);
      final transport = await _transportService.getAllTransportCompanies();
      final delivery = await _deliveryService.getDeliveryCompanies();
      final travelAgencies = await _travelAgencyService.getAllTravelAgencies();
      final touristAreas = await TouristAreaService.getAllTouristAreas();
      
      setState(() {
        _featuredRestaurants = restaurants;
        _featuredHotels = hotels;
        _featuredTransport = transport.take(1).toList();
        _featuredDelivery = delivery.take(1).toList();
        _featuredTravelAgencies = travelAgencies.take(1).toList();
        _featuredTouristAreas = touristAreas.take(1).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Custom Title Bar with Profile Icon
            _buildTitleBar(context),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.medium,
                  right: AppSpacing.medium,
                  top: AppSpacing.medium,
                  bottom: AppSpacing.extraLarge * 2, // Extra padding to prevent overflow
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    _buildWelcomeSection(),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Categories Section
                    _buildCategoriesSection(),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Featured Services Section
                    _buildFeaturedServicesSection(),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // AI Assistant Section
                    _buildAIAssistantSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // Bottom Navigation Bar
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
    );
  }
  
  Widget _buildTitleBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.small,
        left: AppSpacing.medium,
        right: AppSpacing.medium,
        bottom: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Title
          Text(
            AppStrings.appName,
            style: GoogleFonts.amiri(
              fontSize: AppFontSizes.extraLarge,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Profile Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            ),
            child: IconButton(
              onPressed: () {
                context.go(AppRoutes.profile);
              },
              icon: Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مرحباً بك في بوابة الجزائر',
            style: GoogleFonts.amiri(
              fontSize: AppFontSizes.extraLarge,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            _welcomeText,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.medium,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppBorderRadius.medium),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    'ابحث عن الخدمات...',
                    style: GoogleFonts.tajawal(
                      fontSize: AppFontSizes.medium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoriesSection() {
    final categories = [
      {
        'title': AppStrings.restaurants,
        'icon': Icons.restaurant,
        'color': const Color(0xFFEF4444),
      },
      {
        'title': AppStrings.hotels,
        'icon': Icons.hotel,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': AppStrings.transport,
        'icon': Icons.directions_car,
        'color': const Color(0xFF10B981),
      },
      {
        'title': AppStrings.delivery,
        'icon': Icons.delivery_dining,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': AppStrings.travel,
        'icon': Icons.flight,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'title': AppStrings.tourism,
        'icon': Icons.landscape,
        'color': const Color(0xFF06B6D4),
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الفئات الرئيسية',
          style: GoogleFonts.tajawal(
            fontSize: AppFontSizes.large,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        
        // Horizontal Scrollable Category Cards
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: EdgeInsets.only(
                  left: index == categories.length - 1 ? 0 : AppSpacing.medium,
                ),
                child: _buildCategoryCard(
                  context: context,
                  title: category['title'] as String,
                  icon: category['icon'] as IconData,
                  color: category['color'] as Color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == AppStrings.restaurants) {
          context.push(AppRoutes.restaurants);
        } else if (title == AppStrings.hotels) {
          context.push(AppRoutes.hotels);
        } else if (title == AppStrings.transport) {
          context.push(AppRoutes.transportCompanies);
        } else if (title == AppStrings.delivery) {
          context.push(AppRoutes.deliveryCompanies);
        } else if (title == AppStrings.travel) {
          context.push(AppRoutes.travelAgencies);
        } else if (title == AppStrings.tourism) {
          context.push(AppRoutes.touristAreas);
        } else if (title == AppStrings.aiTrip) {
          context.push(AppRoutes.aiTrip);
        } else {
          // TODO: Navigate to other category screens
        }
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.accent.withOpacity(0.05),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.extraSmall),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title,
                style: GoogleFonts.tajawal(
                  fontSize: AppFontSizes.extraSmall,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomNavBar(BuildContext context) {
    return CustomBottomNav(
      currentIndex: 0, // Home is always selected
      onTap: (index) {
        // Handle navigation based on index
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            // Navigate to search
            break;
          case 2:
            // Navigate to favorites
            context.go(AppRoutes.favorites);
            break;
          case 3:
            // Navigate to AI
            context.push(AppRoutes.aiTrip);
            break;
          case 4:
            // Navigate to orders
            break;
          case 5:
            // Navigate to profile
            context.go(AppRoutes.profile);
            break;
        }
      },
    );
  }

  Widget _buildFeaturedServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الخدمات المميزة',
              style: GoogleFonts.tajawal(
                fontSize: AppFontSizes.large,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'عرض الكل',
                style: GoogleFonts.tajawal(
                  fontSize: AppFontSizes.small,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length + _featuredTravelAgencies.length + _featuredTouristAreas.length,
                  itemBuilder: (context, index) {
                    // تحديد نوع الخدمة بناءً على الفهرس
                    if (index < _featuredRestaurants.length) {
                      return _buildServiceCard(
                        title: _featuredRestaurants[index].name,
                        description: _featuredRestaurants[index].description ?? 'مطعم مميز',
                        rating: _featuredRestaurants[index].rating ?? 0.0,
                        icon: Icons.restaurant,
                        color: const Color(0xFFEF4444),
                        index: index,
                        totalCount: _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length + _featuredTravelAgencies.length + _featuredTouristAreas.length,
                      );
                    } else if (index < _featuredRestaurants.length + _featuredHotels.length) {
                      final hotelIndex = index - _featuredRestaurants.length;
                      return _buildServiceCard(
                        title: _featuredHotels[hotelIndex].name,
                        description: _featuredHotels[hotelIndex].description ?? 'فندق مميز',
                        rating: _featuredHotels[hotelIndex].rating ?? 0.0,
                        icon: Icons.hotel,
                        color: const Color(0xFF3B82F6),
                        index: index,
                        totalCount: _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length + _featuredTravelAgencies.length + _featuredTouristAreas.length,
                      );
                    } else if (index < _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length) {
                      final transportIndex = index - _featuredRestaurants.length - _featuredHotels.length;
                      return _buildServiceCard(
                        title: _featuredTransport[transportIndex].name,
                        description: _featuredTransport[transportIndex].description ?? 'شركة نقل موثوقة',
                        rating: _featuredTransport[transportIndex].rating ?? 0.0,
                        icon: Icons.directions_car,
                        color: const Color(0xFF10B981),
                        index: index,
                        totalCount: _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length + _featuredTravelAgencies.length + _featuredTouristAreas.length,
                      );
                    } else if (index < _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length) {
                      final deliveryIndex = index - _featuredRestaurants.length - _featuredHotels.length - _featuredTransport.length;
                      return _buildServiceCard(
                        title: _featuredDelivery[deliveryIndex].name,
                        description: _featuredDelivery[deliveryIndex].description ?? 'خدمة توصيل سريعة',
                        rating: _featuredDelivery[deliveryIndex].rating ?? 0.0,
                        icon: Icons.delivery_dining,
                        color: const Color(0xFFF59E0B),
                        index: index,
                        totalCount: _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length + _featuredTravelAgencies.length + _featuredTouristAreas.length,
                      );
                    } else if (index < _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length + _featuredTravelAgencies.length) {
                      final travelIndex = index - _featuredRestaurants.length - _featuredHotels.length - _featuredTransport.length - _featuredDelivery.length;
                      return _buildServiceCard(
                        title: _featuredTravelAgencies[travelIndex].name,
                        description: _featuredTravelAgencies[travelIndex].description ?? 'وكالة سفر متميزة',
                        rating: _featuredTravelAgencies[travelIndex].rating ?? 0.0,
                        icon: Icons.flight,
                        color: const Color(0xFF8B5CF6),
                        index: index,
                        totalCount: _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length + _featuredTravelAgencies.length + _featuredTouristAreas.length,
                      );
                    } else {
                      final touristIndex = index - _featuredRestaurants.length - _featuredHotels.length - _featuredTransport.length - _featuredDelivery.length - _featuredTravelAgencies.length;
                      return _buildServiceCard(
                        title: _featuredTouristAreas[touristIndex].name,
                        description: _featuredTouristAreas[touristIndex].description ?? 'منطقة سياحية رائعة',
                        rating: _featuredTouristAreas[touristIndex].rating ?? 0.0,
                        icon: Icons.landscape,
                        color: const Color(0xFF06B6D4),
                        index: index,
                        totalCount: _featuredRestaurants.length + _featuredHotels.length + _featuredTransport.length + _featuredDelivery.length + _featuredTravelAgencies.length + _featuredTouristAreas.length,
                      );
                    }
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildAIAssistantSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المساعد الذكي',
          style: GoogleFonts.tajawal(
            fontSize: AppFontSizes.large,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.large),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.accent.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/ai-assistant.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.smart_toy,
                        color: AppColors.primary,
                        size: 50,
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.medium),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مساعدك الشخصي',
                          style: GoogleFonts.tajawal(
                            fontSize: AppFontSizes.large,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.extraSmall),
                        Text(
                          'اسأل عن أي خدمة أو احصل على توصيات مخصصة',
                          style: GoogleFonts.tajawal(
                            fontSize: AppFontSizes.medium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              Row(
                children: [
                  Expanded(
                    child: _buildAIFeatureItem(
                      icon: Icons.search,
                      title: 'البحث الذكي',
                      subtitle: 'ابحث بالصوت أو النص',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: _buildAIFeatureItem(
                      icon: Icons.recommend,
                      title: 'التوصيات',
                      subtitle: 'اقتراحات مخصصة لك',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AiTripScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                    ),
                  ),
                  child: Text(
                    'ابدأ المحادثة',
                    style: GoogleFonts.tajawal(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppBorderRadius.small),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            title,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.small,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.extraSmall),
          Text(
            subtitle,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.extraSmall,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.small,
        horizontal: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.small),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: AppSpacing.extraSmall),
          Text(
            title,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.extraSmall,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String description,
    required double rating,
    required IconData icon,
    required Color color,
    required int index,
    required int totalCount,
  }) {
    return Container(
      width: 280,
      height: 220,
      margin: EdgeInsets.only(
        left: index == (totalCount - 1) ? 0 : AppSpacing.medium,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.medium),
                topRight: Radius.circular(AppBorderRadius.medium),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 60,
                color: color,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.small),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.tajawal(
                          fontSize: AppFontSizes.medium,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating.toStringAsFixed(1),
                          style: GoogleFonts.tajawal(
                            fontSize: AppFontSizes.small,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    description,
                    style: GoogleFonts.tajawal(
                      fontSize: AppFontSizes.small,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}