import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  
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
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate sign up process
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to home screen
      if (mounted) {
        context.go(AppRoutes.home);
      }
    }
  }

  void _navigateToLogin() {
    context.go(AppRoutes.login);
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
                  // Logo/Image Section
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppBorderRadius.large),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppBorderRadius.large),
                        child: Image.asset(
                          AppImages.authSignUp,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.large),
                  
                  // Title Text
                  Text(
                    AppStrings.createAccount,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: AppFontSizes.extraLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.extraLarge),
                  
                  // Sign Up Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name Field
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: AppStrings.fullName,
                            labelStyle: GoogleFonts.tajawal(
                              color: AppColors.textSecondary,
                            ),
                            prefixIcon: const Icon(
                              Icons.person_outline,
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
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppSpacing.medium),
                        
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
                        
                        const SizedBox(height: AppSpacing.medium),
                        
                        // Phone Field
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            labelText: AppStrings.phoneNumber,
                            labelStyle: GoogleFonts.tajawal(
                              color: AppColors.textSecondary,
                            ),
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
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
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppSpacing.medium),
                        
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            labelText: AppStrings.password,
                            labelStyle: GoogleFonts.tajawal(
                              color: AppColors.textSecondary,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
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
                            if (value.length < 6) {
                              return AppStrings.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppSpacing.medium),
                        
                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            labelText: AppStrings.confirmPassword,
                            labelStyle: GoogleFonts.tajawal(
                              color: AppColors.textSecondary,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
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
                            if (value != _passwordController.text) {
                              return AppStrings.passwordsNotMatch;
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: AppSpacing.extraLarge),
                        
                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signUp,
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
                                    AppStrings.signUp,
                                    style: GoogleFonts.tajawal(
                                      fontSize: AppFontSizes.large,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: AppSpacing.extraLarge),
                        
                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.alreadyHaveAccount,
                              style: GoogleFonts.tajawal(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: _navigateToLogin,
                              child: Text(
                                AppStrings.login,
                                style: GoogleFonts.tajawal(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}