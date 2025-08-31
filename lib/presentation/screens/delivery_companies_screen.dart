import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../models/delivery_company_model.dart';
import '../../services/delivery_service.dart';
import '../widgets/unified_app_bar.dart';
import '../widgets/search_filter_widget.dart';
import '../widgets/advertisement_banner.dart';

class DeliveryCompaniesScreen extends StatefulWidget {
  const DeliveryCompaniesScreen({super.key});

  @override
  State<DeliveryCompaniesScreen> createState() => _DeliveryCompaniesScreenState();
}

class _DeliveryCompaniesScreenState extends State<DeliveryCompaniesScreen> {
  final DeliveryService _deliveryService = DeliveryService();
  final TextEditingController _searchController = TextEditingController();
  
  List<DeliveryCompany> _companies = [];
  List<DeliveryCompany> _filteredCompanies = [];
  List<String> _availableWilayas = [];
  
  bool _isLoading = true;
  String _selectedWilaya = 'الكل';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      
      final companies = await _deliveryService.getDeliveryCompanies();
      final wilayas = await _deliveryService.getAvailableWilayas();
      
      setState(() {
        _companies = companies;
        _filteredCompanies = companies;
        _availableWilayas = ['الكل', ...wilayas];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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

  void _filterCompanies() {
    setState(() {
      _filteredCompanies = _companies.where((company) {
        final matchesSearch = _searchQuery.isEmpty ||
            company.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (company.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
        
        final matchesWilaya = _selectedWilaya == 'الكل' ||
            (company.coverageAreas?.any((area) => 
                area.wilaya?.toLowerCase() == _selectedWilaya.toLowerCase()) ?? false);
        
        return matchesSearch && matchesWilaya;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterCompanies();
  }

  void _onWilayaChanged(String? wilaya) {
    if (wilaya != null) {
      _selectedWilaya = wilaya;
      _filterCompanies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: UnifiedAppBar(
        pageType: PageType.delivery,
        title: 'شركات التوصيل',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Advertisement Banner
          const YalledinAdBanner(),
          const SizedBox(height: 8),
          // Companies List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCompanies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد شركات توصيل',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredCompanies.length,
                          itemBuilder: (context, index) {
                            return _buildCompanyCard(_filteredCompanies[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: SearchFilterWidget(
        onSearchChanged: _onSearchChanged,
        searchHint: 'البحث عن شركة توصيل...',
        filterOptions: _availableWilayas,
        onFilterChanged: (filters) {
          _onWilayaChanged(filters['wilaya']);
        },
      ),
    );
  }

  Widget _buildCompanyCard(DeliveryCompany company) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showCompanyDetails(company),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Header
              Row(
                children: [
                  // Company Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    child: company.coverImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              company.coverImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.local_shipping,
                                  color: AppColors.primary,
                                  size: 30,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.local_shipping,
                            color: AppColors.primary,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 12),
                  // Company Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name,
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              company.rating.toStringAsFixed(1),
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${company.totalReviews})',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Column(
                    children: [
                      // Call Button
                      if (company.phone != null) ...[
                        GestureDetector(
                          onTap: () => _callCompany(company.phone!),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.phone,
                              size: 20,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Delivery Info
              Row(
                children: [
                  if (company.deliveryTime != null) ...[
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      company.deliveryTime!,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (company.deliveryTime != null && company.priceRange != null)
                    const SizedBox(width: 16),
                  if (company.priceRange != null) ...[
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      company.priceRange!,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              // Description
              if (company.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  company.description!,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCompanyDetails(DeliveryCompany company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Header
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primary.withOpacity(0.1),
                            ),
                            child: company.coverImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      company.coverImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.local_shipping,
                                          color: AppColors.primary,
                                          size: 40,
                                        );
                                      },
                                    ),
                                  )
                                : Icon(
                                    Icons.local_shipping,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  company.name,
                                  style: GoogleFonts.cairo(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      company.rating.toStringAsFixed(1),
                                      style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${company.totalReviews} تقييم)',
                                      style: GoogleFonts.cairo(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Description
                      if (company.description != null) ...[
                        Text(
                          'الوصف',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          company.description!,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Delivery Info
                      Text(
                        'معلومات التوصيل',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (company.deliveryTime != null)
                        _buildInfoRow('وقت التوصيل', company.deliveryTime!),
                      if (company.priceRange != null)
                        _buildInfoRow('نطاق الأسعار', company.priceRange!),
                      const SizedBox(height: 20),
                      // Coverage Areas
                      if (company.coverageAreas != null && company.coverageAreas!.isNotEmpty) ...[
                        Text(
                          'مناطق التغطية',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...company.coverageAreas!.map((area) => 
                          _buildCoverageAreaCard(area)).toList(),
                        const SizedBox(height: 20),
                      ],
                      // Payment Methods
                      if (company.paymentMethods != null && company.paymentMethods!.isNotEmpty) ...[
                        Text(
                          'طرق الدفع',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: company.paymentMethods!.map((method) => 
                            _buildPaymentMethodChip(method)).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // Contact Button
                      if (company.phone != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _callCompany(company.phone!),
                            icon: const Icon(Icons.phone),
                            label: Text(
                              'اتصل بالشركة',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverageAreaCard(DeliveryCoverageArea area) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    area.areaName,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (area.wilaya != null)
                    Text(
                      area.wilaya!,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (area.deliveryFee != null)
              Text(
                '${area.deliveryFee!.toStringAsFixed(0)} دج',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodChip(DeliveryPaymentMethod method) {
    return Chip(
      label: Text(
        method.methodName,
        style: GoogleFonts.cairo(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
      backgroundColor: AppColors.primary.withOpacity(0.1),
      side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
    );
  }

  Future<void> _callCompany(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يمكن إجراء المكالمة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}