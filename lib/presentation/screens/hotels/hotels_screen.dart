import 'package:flutter/material.dart';
import '../../../models/hotel_model.dart';
import '../../../services/hotel_service.dart';
import '../../widgets/unified_app_bar.dart';
import '../../widgets/search_filter_widget.dart';
import '../../widgets/advertisement_banner.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final HotelService _hotelService = HotelService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Hotel> _hotels = [];
  List<Hotel> _filteredHotels = [];
  List<String> _wilayas = [];
  String? _selectedWilaya;
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final [hotels, wilayas] = await Future.wait([
        _hotelService.getAllHotels(),
        _hotelService.getAvailableWilayas(),
      ]);
      
      setState(() {
        _hotels = hotels as List<Hotel>;
        _filteredHotels = _hotels;
        _wilayas = wilayas as List<String>;
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

  Future<void> _searchHotels(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredHotels = _hotels;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final searchResults = await _hotelService.searchHotels(query);
      setState(() {
        _filteredHotels = searchResults;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في البحث: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _filterByWilaya(String? wilaya) async {
    setState(() {
      _selectedWilaya = wilaya;
      _isLoading = true;
    });

    try {
      List<Hotel> hotels;
      if (wilaya == null) {
        hotels = await _hotelService.getAllHotels();
      } else {
        hotels = await _hotelService.getHotelsByWilaya(wilaya);
      }
      
      setState(() {
        _filteredHotels = hotels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تصفية النتائج: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterHotels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty && (_selectedWilaya == null || _selectedWilaya == 'الكل')) {
        _filteredHotels = _hotels;
      } else {
        _filteredHotels = _hotels.where((hotel) {
          final matchesQuery = query.isEmpty || 
              hotel.name.toLowerCase().contains(query) ||
              hotel.description.toLowerCase().contains(query);
          final matchesWilaya = _selectedWilaya == null || 
              _selectedWilaya == 'الكل' || 
              hotel.wilaya == _selectedWilaya;
          return matchesQuery && matchesWilaya;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: UnifiedAppBar(
        pageType: PageType.hotels,
        title: 'الفنادق',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          const AdvertisementBanner(adType: AdType.generic),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredHotels.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hotel_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد فنادق متاحة',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadInitialData,
                        child: ListView.builder(
                          itemCount: _filteredHotels.length,
                          itemBuilder: (context, index) {
                            return _buildHotelCard(_filteredHotels[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: SearchFilterWidget(
        onSearchChanged: (value) {
          _searchController.text = value;
          _filterHotels();
        },
        searchHint: 'البحث عن فندق...',
        filterOptions: ['الكل', ..._wilayas],
        onFilterChanged: (filters) {
          setState(() {
            _selectedWilaya = filters['wilaya'];
          });
          _filterHotels();
        },
      ),
    );
  }

  void _showHotelDetails(Hotel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelDetailScreen(hotelId: hotel.id),
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showHotelDetails(hotel),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              child: hotel.hasCoverImage
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        hotel.coverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      ),
                    )
                  : _buildPlaceholderImage(),
            ),
            // Hotel Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Stars
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (hotel.starRating != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hotel.displayStars,
                            style: TextStyle(
                              color: Colors.amber[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location
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
                          hotel.displayLocation,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating and Reviews
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hotel.formattedRating,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${hotel.totalReviews} تقييم)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      // Price Range
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hotel.displayPriceRange,
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hotel.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      hotel.description!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hotel,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'لا توجد صورة',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class HotelDetailScreen extends StatefulWidget {
  final String hotelId;

  const HotelDetailScreen({super.key, required this.hotelId});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen>
    with SingleTickerProviderStateMixin {
  final HotelService _hotelService = HotelService();
  late TabController _tabController;
  
  Hotel? _detailedHotel;
  List<RoomType> _roomTypes = [];
  List<HotelAmenity> _amenities = [];
  List<HotelImage> _images = [];
  List<HotelPolicy> _policies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadHotelDetails();
  }

  Future<void> _loadHotelDetails() async {
    try {
      final [detailedHotel, roomTypes, amenities, images, policies] =
          await Future.wait([
        _hotelService.getHotelById(widget.hotelId),
        _hotelService.getRoomTypesByHotel(widget.hotelId),
        _hotelService.getHotelAmenities(widget.hotelId),
        _hotelService.getHotelImages(widget.hotelId),
        _hotelService.getHotelPolicies(widget.hotelId),
      ]);

      setState(() {
        _detailedHotel = detailedHotel as Hotel?;
        _roomTypes = roomTypes as List<RoomType>;
        _amenities = amenities as List<HotelAmenity>;
        _images = images as List<HotelImage>;
        _policies = policies as List<HotelPolicy>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل تفاصيل الفندق: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _detailedHotel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final hotel = _detailedHotel!;
    
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App Bar with Image
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.blue[700],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      hotel.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    background: hotel.hasCoverImage
                        ? Image.network(
                            hotel.coverImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.hotel,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.hotel,
                                size: 64,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                ),
                // Hotel Info and Tabs
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Hotel Basic Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (hotel.starRating != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber[100],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            hotel.displayStars,
                                            style: TextStyle(
                                              color: Colors.amber[800],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 8),
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
                                              hotel.displayLocation,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 20,
                                          color: Colors.amber[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          hotel.formattedRating,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${hotel.totalReviews} تقييم',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (hotel.description != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                hotel.description!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Tab Bar
                      Container(
                        color: Colors.white,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.blue[700],
                          unselectedLabelColor: Colors.grey[600],
                          indicatorColor: Colors.blue[700],
                          tabs: const [
                            Tab(text: 'الغرف'),
                            Tab(text: 'المرافق'),
                            Tab(text: 'الصور'),
                            Tab(text: 'السياسات'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Tab Content
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRoomTypesTab(),
                      _buildAmenitiesTab(),
                      _buildImagesTab(),
                      _buildPoliciesTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRoomTypesTab() {
    if (_roomTypes.isEmpty) {
      return const Center(
        child: Text('لا توجد معلومات عن الغرف'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _roomTypes.length,
      itemBuilder: (context, index) {
        final roomType = _roomTypes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomType.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (roomType.description != null)
                  Text(
                    roomType.description!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${roomType.maxOccupancy} أشخاص'),
                    const SizedBox(width: 16),
                    if (roomType.displayRoomSize.isNotEmpty) ...[
                      Icon(Icons.square_foot, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(roomType.displayRoomSize),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (roomType.bedType != null)
                      Text(
                        roomType.bedType!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    Text(
                      roomType.formattedPrice,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmenitiesTab() {
    if (_amenities.isEmpty) {
      return const Center(
        child: Text('لا توجد معلومات عن المرافق'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _amenities.length,
      itemBuilder: (context, index) {
        final amenity = _amenities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              _getAmenityIcon(amenity.amenityType),
              color: Colors.blue[700],
            ),
            title: Text(amenity.amenityName),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: amenity.isFree ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                amenity.displayCost,
                style: TextStyle(
                  color: amenity.isFree ? Colors.green[700] : Colors.orange[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagesTab() {
    if (_images.isEmpty) {
      return const Center(
        child: Text('لا توجد صور إضافية'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        final image = _images[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            image.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.image_not_supported),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPoliciesTab() {
    if (_policies.isEmpty) {
      return const Center(
        child: Text('لا توجد سياسات محددة'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _policies.length,
      itemBuilder: (context, index) {
        final policy = _policies[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (policy.policyTitle != null)
                  Text(
                    policy.policyTitle!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  policy.policyDescription,
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getAmenityIcon(String? amenityType) {
    switch (amenityType) {
      case 'connectivity':
        return Icons.wifi;
      case 'recreation':
        return Icons.pool;
      case 'dining':
        return Icons.restaurant;
      case 'parking':
        return Icons.local_parking;
      default:
        return Icons.check_circle;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}