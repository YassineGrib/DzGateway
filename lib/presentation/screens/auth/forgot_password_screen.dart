import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate sending reset email
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  void _navigateToLogin() {
    context.go(AppRoutes.login);
  }

  void _resendEmail() {
    setState(() {
      _emailSent = false;
    });
    _sendResetEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: _navigateToLogin,
        ),
        title: Text(
          AppStrings.resetPassword,
          style: GoogleFonts.tajawal(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.large),
                  
                  // Logo/Image Section
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppBorderRadius.large),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppBorderRadius.large),
                        child: Image.asset(
                          AppImages.authPassword,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.extraLarge),
                  
                  if (!_emailSent) ..._buildResetForm() else ..._buildSuccessMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResetForm() {
    return [
      // Title Text
      Text(
        AppStrings.resetPassword,
        textAlign: TextAlign.center,
        style: GoogleFonts.amiri(
          fontSize: AppFontSizes.extraLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      
      const SizedBox(height: AppSpacing.medium),
      
      Text(
        'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور',
        textAlign: TextAlign.center,
        style: GoogleFonts.tajawal(
          fontSize: AppFontSizes.medium,
            color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
      
      const SizedBox(height: AppSpacing.extraLarge),
      
      // Reset Form
      Form(
        key: _formKey,
        child: Column(
          children: [
            // Email Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: AppStrings.email,
                labelStyle: GoogleFonts.tajawal(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  borderSide: const BorderSide(
                    color: AppColors.secondary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
              ),
              style: GoogleFonts.tajawal(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.fieldRequired;
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(value)) {
                  return AppStrings.invalidEmail;
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppSpacing.large),
            
            // Send Reset Email Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'إرسال رابط الإعادة',
                        style: GoogleFonts.tajawal(
                          fontSize: AppFontSizes.large,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.large),
            
            // Back to Login Link
            TextButton(
              onPressed: _navigateToLogin,
              child: Text(
                'العودة إلى تسجيل الدخول',
                style: GoogleFonts.tajawal(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildSuccessMessage() {
    return [
      // Success Icon
      Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_outline,
          color: AppColors.success,
          size: 40,
        ),
      ),
      
      const SizedBox(height: AppSpacing.large),
      
      // Success Title
      Text(
        'تم إرسال الرابط!',
        textAlign: TextAlign.center,
        style: GoogleFonts.amiri(
          fontSize: AppFontSizes.extraLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      
      const SizedBox(height: AppSpacing.medium),
      
      // Success Message
      Text(
        'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد والبريد المزعج.',
        textAlign: TextAlign.center,
        style: GoogleFonts.tajawal(
          fontSize: AppFontSizes.medium,
            color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
      
      const SizedBox(height: AppSpacing.extraLarge),
      
      // Resend Button
      SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: _resendEmail,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            ),
          ),
          child: Text(
            'إعادة الإرسال',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      
      const SizedBox(height: AppSpacing.medium),
      
      // Back to Login Button
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _navigateToLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium),
            ),
            elevation: 0,
          ),
          child: Text(
            'العودة إلى تسجيل الدخول',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ];
  }
}