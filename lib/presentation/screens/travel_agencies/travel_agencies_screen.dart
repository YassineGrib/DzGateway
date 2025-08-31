import 'package:flutter/material.dart';
import '../../../models/travel_agency_model.dart';
import '../../../services/travel_agency_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/unified_app_bar.dart';
import '../../widgets/search_filter_widget.dart';

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
  
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedPriceRange;
  
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
      
      setState(() {
        _availablePriceRanges = priceRanges;
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
      floatingActionButton: SearchFilterWidget(
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
          _filterTravelAgencies();
        },
        searchHint: 'ابحث عن وكالة سياحية...',
        filterOptions: _availablePriceRanges.isNotEmpty ? ['الكل', ..._availablePriceRanges] : ['الكل'],
        onFilterChanged: (filters) {
          setState(() {
            // Find the selected price range from the filters map
            String? selectedRange;
            for (String key in filters.keys) {
              if (filters[key] == true && key != 'الكل') {
                selectedRange = key;
                break;
              }
            }
            _selectedPriceRange = selectedRange;
          });
          _filterTravelAgencies();
        },
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