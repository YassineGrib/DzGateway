import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: AppImages.welcomeRestaurant,
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
    ),
    OnboardingData(
      image: AppImages.welcomeDelivery,
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
    ),
    OnboardingData(
      image: AppImages.welcomeHotel,
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
    ),
    OnboardingData(
      image: AppImages.welcomeTransport,
      title: AppStrings.onboardingTitle4,
      description: AppStrings.onboardingDesc4,
    ),
    OnboardingData(
      image: AppImages.welcomeTravel,
      title: AppStrings.onboardingTitle5,
      description: AppStrings.onboardingDesc5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _skipToAuth() {
    _navigateToAuth();
  }

  void _navigateToAuth() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: _skipToAuth,
                    child: Text(
                      AppStrings.skip,
                      style: GoogleFonts.tajawal(
                        fontSize: AppFontSizes.medium,
            color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(data: _pages[index]);
                  },
                ),
              ),
              
              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Column(
                  children: [
                    // Page Indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: WormEffect(
                        dotColor: AppColors.textMuted,
            activeDotColor: AppColors.primary,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 16,
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.large),
                    
                    // Next/Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? AppStrings.getStarted
                              : AppStrings.next,
                          style: GoogleFonts.tajawal(
                            fontSize: AppFontSizes.large,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.large),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.large),
              child: Image.asset(
                data.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.extraLarge),
          
          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: AppFontSizes.xxLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          
          const SizedBox(height: AppSpacing.medium),
          
          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.large,
            color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}