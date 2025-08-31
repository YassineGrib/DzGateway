import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/tourist_area_model.dart';
import '../../../services/tourist_area_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/unified_app_bar.dart';

import '../../widgets/search_filter_widget.dart';

class TouristAreasScreen extends StatefulWidget {
  const TouristAreasScreen({Key? key}) : super(key: key);

  @override
  State<TouristAreasScreen> createState() => _TouristAreasScreenState();
}

class _TouristAreasScreenState extends State<TouristAreasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TouristArea> _allAreas = [];
  List<TouristArea> _algiersAreas = [];
  List<TouristArea> _setifAreas = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTouristAreas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTouristAreas() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('🔍 Loading tourist areas...');
      final areas = await TouristAreaService.getAllTouristAreas();
      print('✅ Loaded ${areas.length} tourist areas');

      setState(() {
        _allAreas = areas;
        _algiersAreas = areas.where((area) => 
            (area.wilaya?.toLowerCase().contains('الجزائر') ?? false) ||
            (area.wilaya?.toLowerCase().contains('algiers') ?? false) ||
            (area.city?.toLowerCase().contains('الجزائر') ?? false) ||
            (area.city?.toLowerCase().contains('algiers') ?? false)
        ).toList();
        _setifAreas = areas.where((area) => 
            (area.wilaya?.toLowerCase().contains('سطيف') ?? false) ||
            (area.wilaya?.toLowerCase().contains('setif') ?? false) ||
            (area.city?.toLowerCase().contains('سطيف') ?? false) ||
            (area.city?.toLowerCase().contains('setif') ?? false)
        ).toList();
        _isLoading = false;
      });

      print('📍 Algiers areas: ${_algiersAreas.length}');
      print('📍 Setif areas: ${_setifAreas.length}');
    } catch (e) {
      print('❌ Error loading tourist areas: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<TouristArea> _getFilteredAreas(List<TouristArea> areas) {
    if (_searchQuery.isEmpty) return areas;
    
    return areas.where((area) {
      return area.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (area.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
             (area.city?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
             (area.wilaya?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: UnifiedAppBar(
        pageType: PageType.tourism,
        title: 'المناطق السياحية',
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'الجزائر العاصمة'),
            Tab(text: 'سطيف'),
          ],
        ),
      ),
      body: Column(
        children: [
          // المحتوى الرئيسي
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'جاري تحميل المناطق السياحية...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'حدث خطأ في تحميل البيانات',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadTouristAreas,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildAreasList(_getFilteredAreas(_allAreas)),
                          _buildAreasList(_getFilteredAreas(_algiersAreas)),
                          _buildAreasList(_getFilteredAreas(_setifAreas)),
                        ],
                      ),
          ),
        ],
      ),
      floatingActionButton: SearchFilterWidget(
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        onFilterChanged: (filters) {
          // يمكن إضافة منطق الفلترة هنا لاحقاً
        },
        searchHint: 'ابحث عن منطقة سياحية...',
      ),
    );
  }

  Widget _buildAreasList(List<TouristArea> areas) {
    if (areas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'لا توجد نتائج للبحث "$_searchQuery"'
                  : 'لا توجد مناطق سياحية متاحة',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (_searchQuery.isNotEmpty) ...
            [
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
                child: const Text('مسح البحث'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTouristAreas,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: areas.length,
        itemBuilder: (context, index) {
          final area = areas[index];
          return _buildAreaCard(area);
        },
      ),
    );
  }

  Widget _buildAreaCard(TouristArea area) {
    final primaryImage = (area.images?.isNotEmpty ?? false)
        ? area.images!.firstWhere(
            (img) => img.displayOrder == 1,
            orElse: () => area.images!.first,
          )
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showAreaDetails(area),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنطقة
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 200,
                width: double.infinity,
                child: primaryImage != null
                    ? CachedNetworkImage(
                        imageUrl: primaryImage.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.landscape,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            
            // معلومات المنطقة
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنطقة والتقييم
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          area.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              area.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // الموقع
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${area.city}, ${area.wilaya}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // نوع المنطقة
                  if (area.areaType?.isNotEmpty ?? false)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.blue[200]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        area.areaType ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 12),
                  
                  // الوصف
                  Text(
                    area.description ?? 'لا يوجد وصف متاح',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // معلومات إضافية
                  Row(
                    children: [
                      if (area.totalReviews > 0) ...
                      [
                        Icon(
                          Icons.reviews,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${area.totalReviews} تقييم',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (area.features?.isNotEmpty ?? false) ...
                      [
                        Icon(
                          Icons.featured_play_list,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${area.features?.length ?? 0} ميزة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAreaDetails(TouristArea area) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // مقبض السحب
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // المحتوى
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم المنطقة والتقييم
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                area.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    area.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // الموقع
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${area.city}, ${area.wilaya}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // الوصف
                        const Text(
                          'الوصف',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          area.description ?? 'لا يوجد وصف متاح',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        
                        // الميزات
                        if (area.features?.isNotEmpty ?? false) ...
                        [
                          const SizedBox(height: 20),
                          const Text(
                            'الميزات',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (area.features ?? []).map((feature) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  feature.featureName,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        
                        // النصائح
                        if (area.tips?.isNotEmpty ?? false) ...
                        [
                          const SizedBox(height: 20),
                          const Text(
                            'نصائح للزيارة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...(area.tips ?? []).map((tip) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber[200]!,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.amber[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      tip.tipContent,
                                      style: TextStyle(
                                        color: Colors.amber[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}