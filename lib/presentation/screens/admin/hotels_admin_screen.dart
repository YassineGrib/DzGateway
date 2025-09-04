import 'package:flutter/material.dart';
import '../../../models/hotel_model.dart';
import '../../../services/hotel_service.dart';
import '../../../services/admin_service.dart';

class HotelsAdminScreen extends StatefulWidget {
  const HotelsAdminScreen({super.key});

  @override
  State<HotelsAdminScreen> createState() => _HotelsAdminScreenState();
}

class _HotelsAdminScreenState extends State<HotelsAdminScreen> {
  List<Hotel> _hotels = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    try {
      final hotels = await HotelService().getAllHotels();
      setState(() {
        _hotels = hotels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل الفنادق: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Hotel> get _filteredHotels {
    if (_searchQuery.isEmpty) {
      return _hotels;
    }
    return _hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hotel.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hotel.wilaya.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Future<void> _deleteHotel(String hotelId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الفندق؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Note: You'll need to implement deleteHotel in HotelService
        // await HotelService.deleteHotel(hotelId);
        await _loadHotels();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف الفندق بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في حذف الفندق: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إدارة الفنادق',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHotels,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade600,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'البحث في الفنادق...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          // Hotels List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredHotels.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hotel,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'لا توجد فنادق'
                                  : 'لا توجد نتائج للبحث',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadHotels,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredHotels.length,
                          itemBuilder: (context, index) {
                            final hotel = _filteredHotels[index];
                            return _buildHotelCard(hotel);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditHotelDialog();
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Hotel Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.blue.shade100,
                    child: hotel.imageUrl != null
                        ? Image.network(
                            hotel.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.hotel,
                                color: Colors.blue.shade600,
                                size: 30,
                              );
                            },
                          )
                        : Icon(
                            Icons.hotel,
                            color: Colors.blue.shade600,
                            size: 30,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Hotel Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(
                            hotel.starRating ?? 0,
                            (index) => Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${hotel.starRating ?? 0} نجوم',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${hotel.address}, ${hotel.wilaya}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddEditHotelDialog(hotel: hotel);
                    } else if (value == 'delete') {
                      _deleteHotel(hotel.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حذف'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Hotel Stats
            Row(
              children: [
                _buildStatChip(
                  Icons.star,
                  hotel.rating.toString(),
                  Colors.amber,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  Icons.reviews,
                  '${hotel.totalReviews} تقييم',
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  Icons.star,
                  '${hotel.rating.toStringAsFixed(1)} نجوم',
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEditHotelDialog({Hotel? hotel}) {
    showDialog(
      context: context,
      builder: (context) => AddEditHotelDialog(
        hotel: hotel,
        onSaved: () {
          _loadHotels();
        },
      ),
    );
  }
}

class AddEditHotelDialog extends StatefulWidget {
  final Hotel? hotel;
  final VoidCallback onSaved;

  const AddEditHotelDialog({
    super.key,
    this.hotel,
    required this.onSaved,
  });

  @override
  State<AddEditHotelDialog> createState() => _AddEditHotelDialogState();
}

class _AddEditHotelDialogState extends State<AddEditHotelDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;

  late TextEditingController _wilayaController;

  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;



  int _starRating = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hotel?.name ?? '');
    _descriptionController = TextEditingController(text: widget.hotel?.description ?? '');
    _addressController = TextEditingController(text: widget.hotel?.address ?? '');
    _wilayaController = TextEditingController(text: widget.hotel?.wilaya ?? '');
    _phoneController = TextEditingController(text: widget.hotel?.phone ?? '');
    _emailController = TextEditingController(text: widget.hotel?.email ?? '');
    _websiteController = TextEditingController(text: widget.hotel?.website ?? '');
    _starRating = widget.hotel?.rating.round() ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _wilayaController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _saveHotel() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Note: You'll need to implement createHotel and updateHotel in HotelService
      /*
      if (widget.hotel == null) {
        // Create new hotel
        await HotelService.createHotel(
          name: _nameController.text,
          description: _descriptionController.text,
          address: _addressController.text,
          wilaya: _wilayaController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          website: _websiteController.text,
        );
      } else {
        // Update existing hotel
        await HotelService.updateHotel(
          hotelId: widget.hotel!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          address: _addressController.text,
          wilaya: _wilayaController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          website: _websiteController.text,
        );
      }
      */
      
      widget.onSaved();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.hotel == null
                  ? 'تم إضافة الفندق بنجاح'
                  : 'تم تحديث الفندق بنجاح',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حفظ الفندق: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              widget.hotel == null ? 'إضافة فندق جديد' : 'تعديل الفندق',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم الفندق *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم الفندق';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'الوصف',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'العنوان *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال العنوان';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _wilayaController,
                        decoration: const InputDecoration(
                          labelText: 'الولاية *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الولاية';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _websiteController,
                        decoration: const InputDecoration(
                          labelText: 'الموقع الإلكتروني',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      // Star Rating
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تصنيف النجوم',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _starRating = index + 1;
                                  });
                                },
                                child: Icon(
                                  Icons.star,
                                  size: 32,
                                  color: index < _starRating
                                      ? Colors.amber[600]
                                      : Colors.grey[300],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveHotel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(widget.hotel == null ? 'إضافة' : 'تحديث'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}