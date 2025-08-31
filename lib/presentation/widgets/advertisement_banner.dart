import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';

enum AdType {
  yassir,
  yalledin,
  generic,
}

class AdvertisementBanner extends StatelessWidget {
  final AdType adType;
  final VoidCallback? onTap;
  final double height;

  const AdvertisementBanner({
    super.key,
    required this.adType,
    this.onTap,
    this.height = 120,
  });

  Map<String, dynamic> _getAdData() {
    switch (adType) {
      case AdType.yassir:
        return {
          'title': 'Yassir',
          'subtitle': 'خدمة النقل الأولى في الجزائر',
          'description': 'احجز رحلتك الآن واستمتع بخصم 20%',
          'color': const Color(0xFF00C853),
          'icon': Icons.directions_car,
          'buttonText': 'احجز الآن',
        };
      case AdType.yalledin:
        return {
          'title': 'Yalledin',
          'subtitle': 'توصيل سريع وآمن',
          'description': 'اطلب طعامك المفضل مع توصيل مجاني',
          'color': const Color(0xFFFF6B35),
          'icon': Icons.delivery_dining,
          'buttonText': 'اطلب الآن',
        };
      case AdType.generic:
        return {
          'title': 'إعلان',
          'subtitle': 'عرض خاص',
          'description': 'اكتشف العروض الجديدة',
          'color': AppColors.primary,
          'icon': Icons.local_offer,
          'buttonText': 'اكتشف المزيد',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final adData = _getAdData();
    final Color adColor = adData['color'];

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            adColor,
            adColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: adColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.large),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Row(
              children: [
                // Icon Section
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  ),
                  child: Icon(
                    adData['icon'],
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                
                // Content Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        adData['title'],
                        style: GoogleFonts.tajawal(
                          fontSize: AppFontSizes.large,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        adData['subtitle'],
                        style: GoogleFonts.tajawal(
                          fontSize: AppFontSizes.small,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        adData['description'],
                        style: GoogleFonts.tajawal(
                          fontSize: AppFontSizes.extraSmall,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Action Button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.small,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  ),
                  child: Text(
                    adData['buttonText'],
                    style: GoogleFonts.tajawal(
                      fontSize: AppFontSizes.small,
                      fontWeight: FontWeight.w600,
                      color: adColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget helper for easy usage
class YassirAdBanner extends StatelessWidget {
  final VoidCallback? onTap;
  final double height;

  const YassirAdBanner({
    super.key,
    this.onTap,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return AdvertisementBanner(
      adType: AdType.yassir,
      onTap: onTap,
      height: height,
    );
  }
}

class YalledinAdBanner extends StatelessWidget {
  final VoidCallback? onTap;
  final double height;

  const YalledinAdBanner({
    super.key,
    this.onTap,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return AdvertisementBanner(
      adType: AdType.yalledin,
      onTap: onTap,
      height: height,
    );
  }
}