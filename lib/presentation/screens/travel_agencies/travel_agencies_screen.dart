import 'package:flutter/material.dart';
import '../../../models/travel_agency_model.dart';
import '../../../services/travel_agency_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/unified_app_bar.dart';
import '../../widgets/search_filter_widget.dart';
import '../../widgets/advertisement_banner.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelAgenciesScreen extends StatefulWidget {
  const TravelAgenciesScreen({super.key});

  @override
  State<TravelAgenciesScreen> createState() => _TravelAgenciesScreenState();
}

class _TravelAgenciesScreenState extends State<TravelAgenciesScreen> {
  final TravelAgencyService _travelAgencyService = TravelAgencyService();
  List<TravelAgency> _allTravelAgencies = [];
  List<TravelAgency> _filteredTravelAgencies = [];
  List<String> _availablePriceRanges = [];
  List<String> _availableOfferTypes = [];
  
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedPriceRange;
  String? _selectedOfferType;
  
  @override
  void initState() {
    super.initState();
    _loadTravelAgencies();
    _loadFilterOptions();
  }

  Future<void> _loadTravelAgencies() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      print('Loading travel agencies...');
      final agencies = await _travelAgencyService.getAllTravelAgencies();
      print('Loaded ${agencies.length} travel agencies');
      
      setState(() {
        _allTravelAgencies = agencies;
        _filteredTravelAgencies = agencies;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading travel agencies: $e');
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل الوكالات السياحية: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _loadFilterOptions() async {
    try {
      final priceRanges = await _travelAgencyService.getAvailablePriceRanges();
      final offerTypes = await _travelAgencyService.getAvailableOfferTypes();
      
      setState(() {
        _availablePriceRanges = priceRanges;
        _availableOfferTypes = offerTypes;
      });
    } catch (e) {
      // Handle error silently for filter options
    }
  }

  void _filterTravelAgencies() {
    setState(() {
      _filteredTravelAgencies = _allTravelAgencies.where((agency) {
        // Search filter
        bool matchesSearch = _searchQuery.isEmpty ||
            agency.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (agency.description ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
        
        // Price range filter
        bool matchesPriceRange = _selectedPriceRange == null ||
            agency.priceRange == _selectedPriceRange;
        
        return matchesSearch && matchesPriceRange;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterTravelAgencies();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'تصفية النتائج',
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price Range Filter
                    Text(
                      'النطاق السعري',
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availablePriceRanges.map((range) {
                        final isSelected = _selectedPriceRange == range;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPriceRange = isSelected ? null : range;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              range,
                              style: GoogleFonts.tajawal(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Offer Type Filter
                    Text(
                      'نوع العرض',
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableOfferTypes.map((type) {
                        final isSelected = _selectedOfferType == type;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedOfferType = isSelected ? null : type;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              type,
                              style: GoogleFonts.tajawal(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Apply Button
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _filterTravelAgencies();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'تطبيق التصفية',
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: UnifiedAppBar(
        pageType: PageType.travel,
        title: 'الوكالات السياحية',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          const AdvertisementBanner(adType: AdType.generic),
          // Search and Filter
          SearchFilterWidget(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            searchHint: 'ابحث عن وكالة سياحية...',
          ),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8B5CF6),
                    ),
                  )
                : _filteredTravelAgencies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flight_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد وكالات سياحية متاحة',
                              style: GoogleFonts.tajawal(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTravelAgencies,
                        color: const Color(0xFF8B5CF6),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredTravelAgencies.length,
                          itemBuilder: (context, index) {
                            final agency = _filteredTravelAgencies[index];
                            return _buildTravelAgencyCard(agency);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelAgencyCard(TravelAgency agency) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.8),
                    const Color(0xFF06B6D4).withOpacity(0.8),
                  ],
                ),
              ),
              child: (agency.images?.isNotEmpty == true)
                  ? Image.network(
                      agency.images!.first.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        agency.name,
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            agency.formattedRating,
                            style: GoogleFonts.tajawal(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  agency.description ?? 'لا يوجد وصف متاح',
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Info Row
                Row(
                  children: [
                    // Phone
                    if (agency.phone?.isNotEmpty == true)
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                agency.phone!,
                                style: GoogleFonts.tajawal(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Price Range
                    if (agency.priceRange?.isNotEmpty == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          agency.priceRange!,
                          style: GoogleFonts.tajawal(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to agency details
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('سيتم إضافة صفحة التفاصيل قريباً'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.info_outline),
                        label: const Text('التفاصيل'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Add contact functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('سيتم إضافة خاصية الاتصال قريباً'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('اتصال'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8B5CF6),
                          side: const BorderSide(color: Color(0xFF8B5CF6)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF8B5CF6).withOpacity(0.8),
            const Color(0xFF06B6D4).withOpacity(0.8),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.flight,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }
}