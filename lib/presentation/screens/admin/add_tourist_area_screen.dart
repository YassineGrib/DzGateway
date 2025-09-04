import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/tourist_area_model.dart';
import '../../../services/tourism_service.dart';
import '../../../services/image_upload_service.dart';

class AddTouristAreaScreen extends StatefulWidget {
  final String? areaId;

  const AddTouristAreaScreen({super.key, this.areaId});

  @override
  State<AddTouristAreaScreen> createState() => _AddTouristAreaScreenState();
}

class _AddTouristAreaScreenState extends State<AddTouristAreaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _wilayaController = TextEditingController();
  final _entryFeeController = TextEditingController();
  final _openingHoursController = TextEditingController();
  final _coverImageController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  bool _isActive = false;
  bool _isLoading = false;
  bool _isEditing = false;
  TouristArea? _currentArea;
  
  // Image handling
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;
  final ImagePicker _picker = ImagePicker();

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
    'تيارت',
    'تيسمسيلت',
    'الوادي',
    'خنشلة',
    'سوق أهراس',
    'تيبازة',
    'ميلة',
    'عين الدفلى',
    'عين تموشنت',
    'برج بوعريريج',
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
    'عين تموشنت',
    'غليزان',
    'إليزي',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.areaId != null) {
      _isEditing = true;
      _loadArea();
    }
  }

  Future<void> _loadArea() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final areas = await TourismService().getAllTouristAreas();
      final area = areas.firstWhere((a) => a.id == widget.areaId);
      
      setState(() {
        _currentArea = area;
        _nameController.text = area.name;
        _descriptionController.text = area.description ?? '';
        _categoryController.text = area.areaType ?? '';
        _locationController.text = area.address ?? '';
        _wilayaController.text = area.wilaya ?? '';
        _entryFeeController.text = area.entryFee?.toString() ?? '';
        _openingHoursController.text = area.openingHours ?? '';
        _coverImageController.text = area.coverImage ?? '';
        _uploadedImageUrl = area.coverImage;
        _latitudeController.text = area.latitude?.toString() ?? '';
        _longitudeController.text = area.longitude?.toString() ?? '';
        _isActive = area.isActive;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل بيانات المنطقة السياحية: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveArea() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final areaData = {
        'name': _nameController.text,
        'description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
        'area_type': _categoryController.text.isEmpty ? null : _categoryController.text,
        'address': _locationController.text.isEmpty ? null : _locationController.text,
        'wilaya': _wilayaController.text.isEmpty ? null : _wilayaController.text,
        'entry_fee': _entryFeeController.text.isEmpty ? null : double.tryParse(_entryFeeController.text),
        'opening_hours': _openingHoursController.text.isEmpty ? null : _openingHoursController.text,
        'cover_image': _coverImageController.text.isEmpty ? null : _coverImageController.text,
        'latitude': _latitudeController.text.isEmpty ? null : double.tryParse(_latitudeController.text),
        'longitude': _longitudeController.text.isEmpty ? null : double.tryParse(_longitudeController.text),
        'is_active': _isActive,
      };

      if (_isEditing && _currentArea != null) {
        await TourismService().updateTouristArea(_currentArea!.id, areaData);
      } else {
        await TourismService().createTouristArea(areaData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'تم تحديث المنطقة السياحية بنجاح'
                  : 'تم إضافة المنطقة السياحية بنجاح',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/admin/tourist-areas');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'تعديل المنطقة السياحية' : 'إضافة منطقة سياحية جديدة',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/tourism'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'المعلومات الأساسية',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'اسم المنطقة السياحية *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.landscape),
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
                                prefixIcon: Icon(Icons.description),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _categoryController.text.isEmpty ? null : _categoryController.text,
                              decoration: const InputDecoration(
                                labelText: 'نوع المنطقة السياحية',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.category),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الموقع',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                labelText: 'العنوان',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _wilayaController.text.isEmpty ? null : _wilayaController.text,
                              decoration: const InputDecoration(
                                labelText: 'الولاية',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.map),
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
                                      prefixIcon: Icon(Icons.my_location),
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
                                      prefixIcon: Icon(Icons.my_location),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'تفاصيل إضافية',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _entryFeeController,
                              decoration: const InputDecoration(
                                labelText: 'رسوم الدخول (دج)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _openingHoursController,
                              decoration: const InputDecoration(
                                labelText: 'ساعات العمل',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _coverImageController,
                              decoration: const InputDecoration(
                                labelText: 'رابط الصورة الرئيسية',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.image),
                              ),
                              keyboardType: TextInputType.url,
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
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.go('/admin/tourist-areas'),
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
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                                : Text(_isEditing ? 'تحديث' : 'إضافة'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}