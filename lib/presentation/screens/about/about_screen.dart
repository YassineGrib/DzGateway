import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'حول التطبيق',
            style: GoogleFonts.amiri(
              fontSize: AppFontSizes.large,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo and Name
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.extraLarge),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.location_city,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: AppSpacing.large),
              
              Text(
                'بوابة الجزائر',
                style: GoogleFonts.amiri(
                  fontSize: AppFontSizes.extraLarge * 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: AppSpacing.small),
              
              Text(
                'الإصدار 1.0.0',
                style: GoogleFonts.tajawal(
                  fontSize: AppFontSizes.medium,
                  color: AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: AppSpacing.extraLarge),
              
              // App Description
              _buildInfoCard(
                title: 'عن التطبيق',
                icon: Icons.info_outline,
                content: 'بوابة الجزائر هو تطبيق شامل يهدف إلى تسهيل الوصول إلى مختلف الخدمات في الجزائر. من المطاعم والفنادق إلى وكالات السفر وشركات النقل، نحن نجمع كل ما تحتاجه في مكان واحد لتجربة سلسة ومريحة.',
              ),
              
              const SizedBox(height: AppSpacing.large),
              
              // Features
              _buildInfoCard(
                title: 'المميزات الرئيسية',
                icon: Icons.star_outline,
                content: '• البحث عن المطاعم والفنادق\n• حجز خدمات السفر والنقل\n• تقييمات ومراجعات المستخدمين\n• خرائط تفاعلية ومعلومات مفصلة\n• دعم اللغة العربية بالكامل\n• واجهة سهلة الاستخدام',
              ),
              
              const SizedBox(height: AppSpacing.large),
              
              // Developer Info
              _buildInfoCard(
                title: 'فريق التطوير',
                icon: Icons.code,
                content: 'تم تطوير هذا التطبيق بواسطة فريق من المطورين الجزائريين المتخصصين في تطوير التطبيقات المحمولة، بهدف خدمة المجتمع الجزائري وتسهيل الحياة اليومية.',
              ),
              
              const SizedBox(height: AppSpacing.large),
              
              // Contact and Social
              _buildSocialSection(),
              
              const SizedBox(height: AppSpacing.large),
              
              // Legal
              _buildLegalSection(),
              
              const SizedBox(height: AppSpacing.extraLarge),
              
              // Copyright
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                ),
                child: Text(
                  '© 2024 بوابة الجزائر. جميع الحقوق محفوظة.',
                  style: GoogleFonts.tajawal(
                    fontSize: AppFontSizes.small,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Text(
                title,
                style: GoogleFonts.amiri(
                  fontSize: AppFontSizes.large,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            content,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.medium,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                ),
                child: const Icon(
                  Icons.share,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Text(
                'تابعنا',
                style: GoogleFonts.amiri(
                  fontSize: AppFontSizes.large,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'فيسبوك',
                color: const Color(0xFF1877F2),
                onTap: () {},
              ),
              _buildSocialButton(
                icon: Icons.alternate_email,
                label: 'تويتر',
                color: const Color(0xFF1DA1F2),
                onTap: () {},
              ),
              _buildSocialButton(
                icon: Icons.camera_alt,
                label: 'إنستغرام',
                color: const Color(0xFFE4405F),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: AppFontSizes.small,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                ),
                child: const Icon(
                  Icons.gavel,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Text(
                'الشروط والأحكام',
                style: GoogleFonts.amiri(
                  fontSize: AppFontSizes.large,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          _buildLegalItem(
            title: 'شروط الاستخدام',
            onTap: () {},
          ),
          _buildLegalItem(
            title: 'سياسة الخصوصية',
            onTap: () {},
          ),
          _buildLegalItem(
            title: 'اتفاقية الترخيص',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLegalItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.tajawal(
                  fontSize: AppFontSizes.medium,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}