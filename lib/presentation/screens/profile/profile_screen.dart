import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/user_model.dart';
import '../../../services/user_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/admin_service.dart';
import '../help/help_screen.dart';
import '../about/about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'العربية';
  UserModel? _userProfile;
  Map<String, int> _userStats = {};
  bool _isLoading = true;
  bool _isAdmin = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await UserService.getCurrentUserProfile();
      final stats = await UserService.getUserStats();
      final isAdmin = await AdminService.isCurrentUserAdmin();
      
      setState(() {
        _userProfile = profile;
        _userStats = stats;
        _isAdmin = isAdmin;
        _nameController.text = profile?.fullName ?? '';
        _phoneController.text = profile?.phone ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل البيانات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => context.go(AppRoutes.home),
            ),
            title: Text(
              'الملف الشخصي',
              style: GoogleFonts.amiri(
                fontSize: AppFontSizes.large,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.go(AppRoutes.home),
          ),
          title: Text(
            'الملف الشخصي',
            style: GoogleFonts.amiri(
              fontSize: AppFontSizes.large,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                _showEditProfileDialog();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: AppSpacing.large),
              _buildStatsSection(),
              const SizedBox(height: AppSpacing.large),
              _buildMenuSection(),
              const SizedBox(height: AppSpacing.large),
              _buildSettingsSection(),
              const SizedBox(height: AppSpacing.large),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: _showImagePicker,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            _userProfile?.fullName ?? 'غير محدد',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.extraLarge,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            _userProfile?.email ?? 'غير محدد',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.medium,
              color: AppColors.textSecondary,
            ),
          ),
          if (_userProfile?.phone != null) ...[
            const SizedBox(height: AppSpacing.small),
            Text(
              _userProfile!.phone!,
              style: GoogleFonts.tajawal(
                fontSize: AppFontSizes.medium,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.small),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.small),
            ),
            child: Text(
              _getRoleDisplayName(_userProfile?.role ?? 'user'),
              style: GoogleFonts.tajawal(
                fontSize: AppFontSizes.small,
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.business,
            count: '${_userStats['services'] ?? 0}',
            label: 'الخدمات',
            color: AppColors.primary,
          ),
          _buildStatItem(
            icon: Icons.star_rate,
            count: '${_userStats['reviews'] ?? 0}',
            label: 'التقييمات',
            color: AppColors.secondary,
          ),
          _buildStatItem(
            icon: Icons.history,
            count: '${_userStats['bookings'] ?? 0}',
            label: 'الحجوزات',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          count,
          style: GoogleFonts.tajawal(
            fontSize: AppFontSizes.large,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.tajawal(
            fontSize: AppFontSizes.small,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'تعديل الملف الشخصي',
            onTap: () => _showEditProfileDialog(),
          ),
          if (_isAdmin) ...[
            _buildMenuItem(
              icon: Icons.admin_panel_settings,
              title: 'لوحة الإدارة',
              onTap: () => context.go(AppRoutes.adminDashboard),
            ),
          ],
          _buildMenuItem(
            icon: Icons.bookmark_outline,
            title: 'المحفوظات',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.history,
            title: 'سجل الحجوزات',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.payment,
            title: 'طرق الدفع',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'العناوين المحفوظة',
            onTap: () {},
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSwitchMenuItem(
            icon: Icons.notifications_outlined,
            title: 'الإشعارات',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchMenuItem(
            icon: Icons.dark_mode_outlined,
            title: 'الوضع الليلي',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildMenuItem(
            icon: Icons.language,
            title: 'اللغة',
            subtitle: _selectedLanguage,
            onTap: () => _showLanguageDialog(),
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'المساعدة والدعم',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'حول التطبيق',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: AppColors.textSecondary,
          ),
          title: Text(
            title,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.medium,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: GoogleFonts.tajawal(
                    fontSize: AppFontSizes.small,
                    color: AppColors.textSecondary,
                  ),
                )
              : null,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textSecondary,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: AppColors.border,
            indent: 56,
          ),
      ],
    );
  }

  Widget _buildSwitchMenuItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: AppColors.textSecondary,
          ),
          title: Text(
            title,
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.medium,
              color: AppColors.textPrimary,
            ),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ),
        Divider(
          height: 1,
          color: AppColors.border,
          indent: 56,
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout),
            const SizedBox(width: AppSpacing.small),
            Text(
              'تسجيل الخروج',
              style: GoogleFonts.tajawal(
                fontSize: AppFontSizes.medium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'تعديل الملف الشخصي',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  labelStyle: GoogleFonts.tajawal(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.small),
                  ),
                ),
                style: GoogleFonts.tajawal(),
              ),
              const SizedBox(height: AppSpacing.medium),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  labelStyle: GoogleFonts.tajawal(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.small),
                  ),
                ),
                style: GoogleFonts.tajawal(),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: GoogleFonts.tajawal(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                
                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'جاري حفظ التغييرات...',
                          style: GoogleFonts.tajawal(),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // Update profile
                final success = await UserService.updateUserProfile(
                  fullName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
                  phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
                );
                
                if (success) {
                  // Reload user data
                  await _loadUserData();
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم حفظ التغييرات بنجاح',
                          style: GoogleFonts.tajawal(),
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'فشل في حفظ التغييرات',
                          style: GoogleFonts.tajawal(),
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                'حفظ',
                style: GoogleFonts.tajawal(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'اختيار اللغة',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('العربية', style: GoogleFonts.tajawal()),
                value: 'العربية',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text('English', style: GoogleFonts.tajawal()),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text('Français', style: GoogleFonts.tajawal()),
                value: 'Français',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'تسجيل الخروج',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
            style: GoogleFonts.tajawal(
              fontSize: AppFontSizes.medium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: GoogleFonts.tajawal(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go(AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: Text(
                'تسجيل الخروج',
                style: GoogleFonts.tajawal(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.large),
        ),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تغيير الصورة الشخصية',
                style: GoogleFonts.amiri(
                  fontSize: AppFontSizes.large,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    icon: Icons.camera_alt,
                    label: 'الكاميرا',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromCamera();
                    },
                  ),
                  _buildImageOption(
                    icon: Icons.photo_library,
                    label: 'المعرض',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromGallery();
                    },
                  ),
                  _buildImageOption(
                    icon: Icons.delete,
                    label: 'حذف الصورة',
                    onTap: () {
                      Navigator.pop(context);
                      _removeProfileImage();
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              label,
              style: GoogleFonts.tajawal(
                fontSize: AppFontSizes.small,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        // TODO: Upload image to Supabase storage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم اختيار الصورة من الكاميرا'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء اختيار الصورة'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        // TODO: Upload image to Supabase storage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم اختيار الصورة من المعرض'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء اختيار الصورة'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeProfileImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف الصورة الشخصية'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'مدير';
      case 'business':
        return 'صاحب عمل';
      case 'user':
      default:
        return 'عضو';
    }
  }
}