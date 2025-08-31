import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../restaurants_screen.dart';
import '../delivery_companies_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    
                    // Recent Activity Section
                    _buildRecentActivitySection(),
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
            'اكتشف أفضل الخدمات والمرافق في جميع أنحاء الجزائر',
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
      // {
      //   'title': AppStrings.aiTrip,
      //   'icon': Icons.smart_toy,
      //   'color': const Color(0xFF9333EA),
      // },
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
        // const SizedBox(height: AppSpacing.medium),
        
        // Grid Category Cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.large,
            mainAxisSpacing: AppSpacing.large,
            childAspectRatio: 1.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              context: context,
              title: category['title'] as String,
              icon: category['icon'] as IconData,
              color: category['color'] as Color,
            );
          },
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
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: AppSpacing.small),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title,
                style: GoogleFonts.tajawal(
                  fontSize: AppFontSizes.extraSmall,
                  color: Colors.white,
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
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final services = [
                {
                  'title': 'مطعم الأصالة',
                  'subtitle': 'أطباق جزائرية تقليدية',
                  'rating': '4.8',
                  'image': Icons.restaurant,
                  'color': const Color(0xFFEF4444),
                },
                {
                  'title': 'فندق الجزائر الكبير',
                  'subtitle': 'إقامة فاخرة في وسط العاصمة',
                  'rating': '4.9',
                  'image': Icons.hotel,
                  'color': const Color(0xFF3B82F6),
                },
                {
                  'title': 'رحلات الصحراء',
                  'subtitle': 'اكتشف جمال الصحراء الجزائرية',
                  'rating': '4.7',
                  'image': Icons.landscape,
                  'color': const Color(0xFF06B6D4),
                },
              ];
              
              final service = services[index];
              return Container(
                width: 280,
                height: 235,
                margin: EdgeInsets.only(
                  left: index == services.length - 1 ? 0 : AppSpacing.medium,
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
                        color: (service['color'] as Color).withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppBorderRadius.medium),
                          topRight: Radius.circular(AppBorderRadius.medium),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          service['image'] as IconData,
                          size: 60,
                          color: service['color'] as Color,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  service['title'] as String,
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
                                    service['rating'] as String,
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
                          const SizedBox(height: AppSpacing.extraSmall),
                          Text(
                            service['subtitle'] as String,
                            style: GoogleFonts.tajawal(
                              fontSize: AppFontSizes.small,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'النشاط الأخير',
          style: GoogleFonts.tajawal(
            fontSize: AppFontSizes.large,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                icon: Icons.restaurant,
                title: 'تم حجز طاولة في مطعم الأصالة',
                time: 'منذ ساعتين',
                color: const Color(0xFFEF4444),
              ),
              const Divider(height: AppSpacing.large),
              _buildActivityItem(
                icon: Icons.hotel,
                title: 'تم حجز غرفة في فندق الجزائر الكبير',
                time: 'أمس',
                color: const Color(0xFF3B82F6),
              ),
              const Divider(height: AppSpacing.large),
              _buildActivityItem(
                icon: Icons.flight,
                title: 'تم حجز رحلة إلى تمنراست',
                time: 'منذ 3 أيام',
                color: const Color(0xFF8B5CF6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.small),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.medium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.tajawal(
                  fontSize: AppFontSizes.medium,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.extraSmall),
              Text(
                time,
                style: GoogleFonts.tajawal(
                  fontSize: AppFontSizes.small,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}