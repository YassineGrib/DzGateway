import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: TextStyle(
            fontFamily: AppFonts.amiri,
            fontSize: AppFontSizes.large,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 80,
              color: AppColors.primary,
            ),
            SizedBox(height: AppSpacing.large),
            Text(
              'مرحباً بك في ${AppStrings.appName}',
              style: TextStyle(
                fontFamily: AppFonts.tajawal,
                fontSize: AppFontSizes.large,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.medium),
            Text(
              'الصفحة الرئيسية قيد التطوير',
              style: TextStyle(
                fontFamily: AppFonts.tajawal,
                fontSize: AppFontSizes.medium,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}