import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
            'المساعدة والدعم',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Section
              _buildSectionCard(
                title: 'تواصل معنا',
                icon: Icons.contact_support,
                children: [
                  _buildContactItem(
                    icon: Icons.email,
                    title: 'البريد الإلكتروني',
                    subtitle: 'support@dzgateway.com',
                    onTap: () {},
                  ),
                  _buildContactItem(
                    icon: Icons.phone,
                    title: 'الهاتف',
                    subtitle: '+213 555 123 456',
                    onTap: () {},
                  ),
                  _buildContactItem(
                    icon: Icons.chat,
                    title: 'الدردشة المباشرة',
                    subtitle: 'متاح من 9 صباحاً إلى 6 مساءً',
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.large),
              
              // FAQ Section
              _buildSectionCard(
                title: 'الأسئلة الشائعة',
                icon: Icons.help_outline,
                children: [
                  _buildFAQItem(
                    question: 'كيف يمكنني إنشاء حساب جديد؟',
                    answer: 'يمكنك إنشاء حساب جديد من خلال النقر على "إنشاء حساب" في صفحة تسجيل الدخول وملء البيانات المطلوبة.',
                  ),
                  _buildFAQItem(
                    question: 'كيف يمكنني حجز خدمة؟',
                    answer: 'اختر الخدمة المطلوبة، حدد التاريخ والوقت المناسب، ثم اتبع خطوات الحجز حتى تأكيد الطلب.',
                  ),
                  _buildFAQItem(
                    question: 'كيف يمكنني إلغاء حجز؟',
                    answer: 'يمكنك إلغاء الحجز من خلال قسم "حجوزاتي" في الملف الشخصي، مع مراعاة سياسة الإلغاء لكل خدمة.',
                  ),
                  _buildFAQItem(
                    question: 'كيف يمكنني تغيير كلمة المرور؟',
                    answer: 'اذهب إلى الإعدادات في الملف الشخصي، ثم اختر "تغيير كلمة المرور" واتبع التعليمات.',
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.large),
              
              // Report Issue Section
              _buildSectionCard(
                title: 'الإبلاغ عن مشكلة',
                icon: Icons.report_problem,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                      border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'واجهت مشكلة؟',
                          style: GoogleFonts.tajawal(
                            fontSize: AppFontSizes.medium,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          'نحن نعتذر عن أي إزعاج. يرجى إرسال تفاصيل المشكلة وسنعمل على حلها في أقرب وقت ممكن.',
                          style: GoogleFonts.tajawal(
                            fontSize: AppFontSizes.small,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _showReportDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warning,
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                            ),
                            child: Text(
                              'إرسال تقرير',
                              style: GoogleFonts.tajawal(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Row(
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
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.medium,
        ),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
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
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.tajawal(
                      fontSize: AppFontSizes.small,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.large,
        vertical: AppSpacing.small,
      ),
      title: Text(
        question,
        style: GoogleFonts.tajawal(
          fontSize: AppFontSizes.medium,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.large,
            right: AppSpacing.large,
            bottom: AppSpacing.medium,
          ),
          child: Text(
            answer,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.small,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    final TextEditingController reportController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'الإبلاغ عن مشكلة',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'يرجى وصف المشكلة التي واجهتها بالتفصيل:',
                style: GoogleFonts.tajawal(
                  fontSize: AppFontSizes.medium,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              TextField(
                controller: reportController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'اكتب وصف المشكلة هنا...',
                  hintStyle: GoogleFonts.tajawal(
                    color: AppColors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.small),
                  ),
                ),
                style: GoogleFonts.tajawal(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                reportController.dispose();
                Navigator.pop(context);
              },
              child: Text(
                'إلغاء',
                style: GoogleFonts.tajawal(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (reportController.text.trim().isNotEmpty) {
                  // Here you would typically send the report to your backend
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم إرسال التقرير بنجاح. شكراً لك!',
                        style: GoogleFonts.tajawal(),
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
                reportController.dispose();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                'إرسال',
                style: GoogleFonts.tajawal(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}