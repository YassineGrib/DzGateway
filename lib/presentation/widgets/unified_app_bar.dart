import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

enum PageType {
  restaurants,
  hotels,
  transport,
  delivery,
  travel,
  tourism,
}

class UnifiedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PageType pageType;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const UnifiedAppBar({
    super.key,
    required this.title,
    required this.pageType,
    this.onBackPressed,
    this.actions,
    this.bottom,
  });

  Color _getPageColor() {
    switch (pageType) {
      case PageType.restaurants:
        return const Color(0xFFEF4444); // أحمر
      case PageType.hotels:
        return const Color(0xFF3B82F6); // أزرق
      case PageType.transport:
        return const Color(0xFF10B981); // أخضر
      case PageType.delivery:
        return const Color(0xFFF59E0B); // برتقالي
      case PageType.travel:
        return const Color(0xFF8B5CF6); // بنفسجي
      case PageType.tourism:
        return const Color(0xFF06B6D4); // سماوي
    }
  }

  IconData _getPageIcon() {
    switch (pageType) {
      case PageType.restaurants:
        return Icons.restaurant;
      case PageType.hotels:
        return Icons.hotel;
      case PageType.transport:
        return Icons.directions_car;
      case PageType.delivery:
        return Icons.delivery_dining;
      case PageType.travel:
        return Icons.flight;
      case PageType.tourism:
        return Icons.landscape;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageColor = _getPageColor();
    final pageIcon = _getPageIcon();

    return AppBar(
      backgroundColor: pageColor,
      elevation: 0,
      centerTitle: true,
      leading: onBackPressed != null
          ? IconButton(
              onPressed: onBackPressed ?? () => context.go(AppRoutes.home),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppBorderRadius.small),
            ),
            child: Icon(
              pageIcon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Text(
            title,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.large,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: actions,
      bottom: bottom,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              pageColor,
              pageColor.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
  );
}