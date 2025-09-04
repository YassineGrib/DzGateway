import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/admin_service.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';
import '../../../core/constants/app_constants.dart';
import 'restaurants_admin_screen.dart';
import 'hotels_admin_screen.dart';
import 'transport_admin_screen.dart';
import 'delivery_admin_screen.dart';
import 'travel_admin_screen.dart';
import 'tourism_admin_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  UserModel? _adminProfile;
  Map<String, int> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final adminProfile = await AdminService.getCurrentAdminProfile();
      
      if (adminProfile == null) {
        // User is not admin, redirect back to login
        if (mounted) {
          context.go(AppRoutes.adminLogin);
          return;
        }
      }
      
      final stats = await AdminService.getAdminStats();
      
      if (mounted) {
        setState(() {
          _adminProfile = adminProfile;
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Dashboard error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // If access denied, redirect to login
        if (e.toString().contains('Access denied') || e.toString().contains('Admin privileges required')) {
          context.go(AppRoutes.adminLogin);
          return;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل البيانات: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await AuthService.signOut();
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تسجيل الخروج: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم المدير',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('تسجيل الخروج'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade600, Colors.blue.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  child: Icon(
                                    Icons.admin_panel_settings,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'مرحباً ${_adminProfile?.fullName ?? 'المدير'}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _adminProfile?.email ?? '',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'إدارة وتحكم في جميع خدمات التطبيق',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Statistics Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.analytics_outlined,
                                color: Colors.blue.shade600,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'إحصائيات النظام',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade50, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue.shade100,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildCleanStatItem(
                                'المطاعم',
                                _stats['restaurants'] ?? 0,
                                Icons.restaurant_outlined,
                                Colors.orange,
                              ),
                              const Divider(height: 24, color: Colors.grey),
                              _buildCleanStatItem(
                                'الفنادق',
                                _stats['hotels'] ?? 0,
                                Icons.hotel_outlined,
                                Colors.purple,
                              ),
                              const Divider(height: 24, color: Colors.grey),
                              _buildCleanStatItem(
                                'النقل',
                                _stats['transport'] ?? 0,
                                Icons.directions_bus_outlined,
                                Colors.green,
                              ),
                              const Divider(height: 24, color: Colors.grey),
                              _buildCleanStatItem(
                                'التوصيل',
                                _stats['delivery'] ?? 0,
                                Icons.delivery_dining_outlined,
                                Colors.red,
                              ),
                              const Divider(height: 24, color: Colors.grey),
                              _buildCleanStatItem(
                                'السفر',
                                _stats['travel'] ?? 0,
                                Icons.flight_outlined,
                                Colors.blue,
                              ),
                              const Divider(height: 24, color: Colors.grey),
                              _buildCleanStatItem(
                                'السياحة',
                                _stats['tourist_areas'] ?? 0,
                                Icons.landscape_outlined,
                                Colors.teal,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Management Options
                    Text(
                      'إدارة الخدمات',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildManagementCard(
                          'إدارة المطاعم',
                          Icons.restaurant_menu,
                          Colors.orange,
                          () => context.go(AppRoutes.adminRestaurants),
                        ),
                        _buildManagementCard(
                          'إدارة الفنادق',
                          Icons.hotel,
                          Colors.purple,
                          () => context.go(AppRoutes.adminHotels),
                        ),
                        _buildManagementCard(
                          'إدارة النقل',
                          Icons.directions_bus,
                          Colors.green,
                          () => context.go(AppRoutes.adminTransport),
                        ),
                        _buildManagementCard(
                          'إدارة التوصيل',
                          Icons.delivery_dining,
                          Colors.red,
                          () => context.go(AppRoutes.adminDelivery),
                        ),
                        _buildManagementCard(
                          'إدارة السفر',
                          Icons.flight_takeoff,
                          Colors.blue,
                          () => context.go(AppRoutes.adminTravel),
                        ),
                        _buildManagementCard(
                          'إدارة السياحة',
                          Icons.landscape,
                          Colors.teal,
                          () => context.go(AppRoutes.adminTourism),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCleanStatItem(String title, int count, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}