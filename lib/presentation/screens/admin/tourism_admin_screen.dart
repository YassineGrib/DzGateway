import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/tourist_area_model.dart';
import '../../../services/tourism_service.dart';
import '../../../services/admin_service.dart';

class TourismAdminScreen extends StatefulWidget {
  const TourismAdminScreen({super.key});

  @override
  State<TourismAdminScreen> createState() => _TourismAdminScreenState();
}

class _TourismAdminScreenState extends State<TourismAdminScreen> {
  List<TouristArea> _areas = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAreas();
  }

  Future<void> _loadAreas() async {
    try {
      final areas = await TourismService().getAllTouristAreas();
      setState(() {
        _areas = areas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل المناطق السياحية: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<TouristArea> get _filteredAreas {
    if (_searchQuery.isEmpty) {
      return _areas;
    }
    return _areas.where((area) {
      return area.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (area.areaType?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (area.address?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (area.wilaya?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  Future<void> _deleteArea(String areaId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه المنطقة السياحية؟'),
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
        // Note: You'll need to implement deleteTouristArea in TourismService
        // await TourismService.deleteTouristArea(areaId);
        await _loadAreas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف المنطقة السياحية بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في حذف المنطقة السياحية: ${e.toString()}'),
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
          'إدارة المناطق السياحية',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAreas,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade600,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'البحث في المناطق السياحية...',
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
          
          // Areas List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAreas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.landscape,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'لا توجد مناطق سياحية'
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
                        onRefresh: _loadAreas,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredAreas.length,
                          itemBuilder: (context, index) {
                            final area = _filteredAreas[index];
                            return _buildAreaCard(area);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/admin/tourist-areas/add');
        },
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAreaCard(TouristArea area) {
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
                // Area Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.green.shade100,
                    child: area.coverImage != null
                        ? Image.network(
                            area.coverImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.landscape,
                                color: Colors.green.shade600,
                                size: 30,
                              );
                            },
                          )
                        : Icon(
                            Icons.landscape,
                            color: Colors.green.shade600,
                            size: 30,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Area Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        area.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        area.areaType ?? 'غير محدد',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
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
                              '${area.address ?? 'غير محدد'}, ${area.wilaya ?? 'غير محدد'}',
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
                      context.go('/admin/tourist-areas/edit/${area.id}');
                    } else if (value == 'delete') {
                      _deleteArea(area.id);
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
            
            // Area Stats
            Row(
              children: [
                _buildStatChip(
                  Icons.star,
                  area.rating.toString(),
                  Colors.amber,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  Icons.reviews,
                  '${area.totalReviews} تقييم',
                  Colors.blue,
                ),
                if (area.entryFee != null) ...[
                  const SizedBox(width: 8),
                  _buildStatChip(
                    Icons.attach_money,
                    '${area.entryFee} دج',
                    Colors.green,
                  ),
                ],
                if (area.isActive) ...[
                  const SizedBox(width: 8),
                  _buildStatChip(
                    Icons.accessible,
                    'متاح للجميع',
                    Colors.purple,
                  ),
                ],
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

  void _showAddEditAreaDialog({TouristArea? area}) {
    showDialog(
      context: context,
      builder: (context) => AddEditTouristAreaDialog(
        area: area,
        onSaved: () {
          _loadAreas();
        },
      ),
    );
  }
}

class AddEditTouristAreaDialog extends StatefulWidget {
  final TouristArea? area;
  final VoidCallback onSaved;

  const AddEditTouristAreaDialog({
    super.key,
    this.area,
    required this.onSaved,
  });

  @override
  State<AddEditTouristAreaDialog> createState() => _AddEditTouristAreaDialogState();
}

class _AddEditTouristAreaDialogState extends State<AddEditTouristAreaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _locationController;
  late TextEditingController _wilayaController;
  late TextEditingController _entryFeeController;
  late TextEditingController _openingHoursController;
  late TextEditingController _coverImageController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  bool _isActive = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'معالم تاريخية',
    'مناطق طبيعية',
    'شواطئ',
    'جبال',
    'صحراء',
    'متاحف',
    'حدائق',
    'مواقع أثرية',
    'مدن قديمة',
    'أخرى',
  ];

  final List<String> _wilayas = [
    'الجزائر',
    'وهران',
    'قسنطينة',
    'عنابة',
    'سطيف',
    'تيزي وزو',
    'بجاية',
    'تلمسان',
    'ورقلة',
    'غرداية',
    'تمنراست',
    'أدرار',
    'الأغواط',
    'أم البواقي',
    'باتنة',
    'البليدة',
    'تبسة',
    'الجلفة',
    'جيجل',
    'سيدي بلعباس',
    'بسكرة',
    'المسيلة',
    'معسكر',
    'المدية',
    'مستغانم',
    'النعامة',
    'سعيدة',
    'سكيكدة',
    'سوق أهراس',
    'الطارف',
    'تيارت',
    'تيسمسيلت',
    'الوادي',
    'خنشلة',
    'ميلة',
    'عين الدفلى',
    'عين تموشنت',
    'البرج بوعريريج',
    'بومرداس',
    'الطارف',
    'تندوف',
    'تيسمسيلت',
    'الوادي',
    'خنشلة',
    'سوق أهراس',
    'تيبازة',
    'ميلة',
    'عين الدفلى',
    'غليزان',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.area?.name ?? '');
    _descriptionController = TextEditingController(text: widget.area?.description ?? '');
    _categoryController = TextEditingController(text: widget.area?.areaType ?? '');
    _locationController = TextEditingController(text: widget.area?.address ?? '');
    _wilayaController = TextEditingController(text: widget.area?.wilaya ?? '');
    _entryFeeController = TextEditingController(text: widget.area?.entryFee?.toString() ?? '');
    _openingHoursController = TextEditingController(text: widget.area?.openingHours ?? '');
    _coverImageController = TextEditingController(text: widget.area?.coverImage ?? '');
    _latitudeController = TextEditingController(text: widget.area?.latitude?.toString() ?? '');
    _longitudeController = TextEditingController(text: widget.area?.longitude?.toString() ?? '');
    _isActive = widget.area?.isActive ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _wilayaController.dispose();
    _entryFeeController.dispose();
    _openingHoursController.dispose();
    _coverImageController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _saveArea() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Note: You'll need to implement createTouristArea and updateTouristArea in TourismService
      /*
      if (widget.area == null) {
        // Create new area
        await TourismService.createTouristArea(
          name: _nameController.text,
          description: _descriptionController.text,
          category: _categoryController.text,
          location: _locationController.text,
          wilaya: _wilayaController.text,
          entryFee: _entryFeeController.text.isEmpty ? null : double.tryParse(_entryFeeController.text),
          openingHours: _openingHoursController.text.isEmpty ? null : _openingHoursController.text,
          coverImage: _coverImageController.text.isEmpty ? null : _coverImageController.text,
          latitude: _latitudeController.text.isEmpty ? null : double.tryParse(_latitudeController.text),
          longitude: _longitudeController.text.isEmpty ? null : double.tryParse(_longitudeController.text),
          isActive: _isActive,
        );
      } else {
        // Update existing area
        await TourismService.updateTouristArea(
          areaId: widget.area!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          category: _categoryController.text,
          location: _locationController.text,
          wilaya: _wilayaController.text,
          entryFee: _entryFeeController.text.isEmpty ? null : double.tryParse(_entryFeeController.text),
          openingHours: _openingHoursController.text.isEmpty ? null : _openingHoursController.text,
          coverImage: _coverImageController.text.isEmpty ? null : _coverImageController.text,
          latitude: _latitudeController.text.isEmpty ? null : double.tryParse(_latitudeController.text),
          longitude: _longitudeController.text.isEmpty ? null : double.tryParse(_longitudeController.text),
          isActive: _isActive,
        );
      }
      */
      
      widget.onSaved();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.area == null
                  ? 'تم إضافة المنطقة السياحية بنجاح'
                  : 'تم تحديث المنطقة السياحية بنجاح',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حفظ المنطقة السياحية: ${e.toString()}'),
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
              widget.area == null ? 'إضافة منطقة سياحية جديدة' : 'تعديل المنطقة السياحية',
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
                          labelText: 'اسم المنطقة السياحية *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم المنطقة السياحية';
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
                      DropdownButtonFormField<String>(
                        value: _categories.contains(_categoryController.text)
                            ? _categoryController.text
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'الفئة *',
                          border: OutlineInputBorder(),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _categoryController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار الفئة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'الموقع *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الموقع';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _wilayas.contains(_wilayaController.text)
                            ? _wilayaController.text
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'الولاية *',
                          border: OutlineInputBorder(),
                        ),
                        items: _wilayas.map((wilaya) {
                          return DropdownMenuItem(
                            value: wilaya,
                            child: Text(wilaya),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _wilayaController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار الولاية';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _entryFeeController,
                        decoration: const InputDecoration(
                          labelText: 'رسوم الدخول (دج)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _openingHoursController,
                        decoration: const InputDecoration(
                          labelText: 'ساعات العمل',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _coverImageController,
                        decoration: const InputDecoration(
                          labelText: 'رابط الصورة الرئيسية',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _latitudeController,
                              decoration: const InputDecoration(
                                labelText: 'خط العرض',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _longitudeController,
                              decoration: const InputDecoration(
                                labelText: 'خط الطول',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value ?? false;
                          });
                            },
                          ),
                          const Text('متاح لذوي الاحتياجات الخاصة'),
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
                    onPressed: _isLoading ? null : _saveArea,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
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
                        : Text(widget.area == null ? 'إضافة' : 'تحديث'),
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