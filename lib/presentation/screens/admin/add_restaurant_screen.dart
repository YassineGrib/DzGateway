import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../../../models/restaurant_model.dart';
import '../../../services/restaurant_service.dart';
import '../../../services/image_upload_service.dart';
import '../../../core/constants/app_constants.dart';

class AddRestaurantScreen extends StatefulWidget {
  final Restaurant? restaurant;
  final String? restaurantId;

  const AddRestaurantScreen({super.key, this.restaurant, this.restaurantId});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  
  // State variables
  bool _isLoading = false;
  bool _isActive = true;
  XFile? _coverImageFile;
  String? _coverImageUrl;
  List<XFile> _additionalImages = [];
  List<String> _additionalImageUrls = [];
  
  final ImagePicker _imagePicker = ImagePicker();
  final RestaurantService _restaurantService = RestaurantService();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.restaurant?.name ?? '');
    _descriptionController = TextEditingController(text: widget.restaurant?.description ?? '');
    _addressController = TextEditingController(text: widget.restaurant?.address ?? '');
    _phoneController = TextEditingController(text: widget.restaurant?.phone ?? '');
    _latitudeController = TextEditingController(
      text: widget.restaurant?.latitude?.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: widget.restaurant?.longitude?.toString() ?? '',
    );
    
    if (widget.restaurant != null) {
      _isActive = widget.restaurant!.isActive;
      _coverImageUrl = widget.restaurant!.coverImage;
      _additionalImageUrls = widget.restaurant!.images?.map((img) => img.imageUrl).toList() ?? [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _coverImageFile = image;
        });
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في اختيار الصورة: ${e.toString()}');
    }
  }

  Future<void> _pickAdditionalImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          _additionalImages.addAll(images);
        });
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في اختيار الصور: ${e.toString()}');
    }
  }

  void _removeAdditionalImage(int index) {
    setState(() {
      if (index < _additionalImages.length) {
        _additionalImages.removeAt(index);
      } else {
        _additionalImageUrls.removeAt(index - _additionalImages.length);
      }
    });
  }

  Future<String?> _uploadImage(XFile imageFile, String folder) async {
    try {
      return await ImageUploadService.uploadImage(imageFile, folder);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في رفع الصورة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  Future<void> _saveRestaurant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? coverImageUrl = _coverImageUrl;
      
      // Upload cover image if selected
      if (_coverImageFile != null) {
        coverImageUrl = await _uploadImage(_coverImageFile!, 'restaurants/covers');
        if (coverImageUrl == null) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // Upload additional images
      List<String> uploadedImageUrls = List.from(_additionalImageUrls);
      if (_additionalImages.isNotEmpty) {
        final galleryUrls = await ImageUploadService.uploadMultipleImages(
          _additionalImages,
          'restaurants/gallery',
        );
        uploadedImageUrls.addAll(galleryUrls);
      }

      // Prepare restaurant data
      final restaurantData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        'latitude': _latitudeController.text.trim().isEmpty 
            ? null 
            : double.tryParse(_latitudeController.text.trim()),
        'longitude': _longitudeController.text.trim().isEmpty 
            ? null 
            : double.tryParse(_longitudeController.text.trim()),
        'cover_image': coverImageUrl,
        'is_active': _isActive,
      };

      Restaurant savedRestaurant;
      if (widget.restaurant == null) {
        // Create new restaurant
        final currentUser = Supabase.instance.client.auth.currentUser;
        final newRestaurant = Restaurant(
          id: '', // Will be generated by database
          name: restaurantData['name'] as String,
          address: restaurantData['address'] as String,
          latitude: restaurantData['latitude'] as double?,
          longitude: restaurantData['longitude'] as double?,
          phone: restaurantData['phone'] as String?,
          description: restaurantData['description'] as String?,
          coverImage: restaurantData['cover_image'] as String?,
          isActive: restaurantData['is_active'] as bool,
          ownerId: currentUser?.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        savedRestaurant = await _restaurantService.createRestaurant(newRestaurant);
      } else {
        // Update existing restaurant
        savedRestaurant = await _restaurantService.updateRestaurant(
          widget.restaurant!.id,
          restaurantData,
        );
      }

      // Add additional images to restaurant_images table
      for (int i = 0; i < uploadedImageUrls.length; i++) {
        if (!_additionalImageUrls.contains(uploadedImageUrls[i])) {
          final restaurantImage = RestaurantImage(
            id: '', // Will be generated by database
            restaurantId: savedRestaurant.id,
            imageUrl: uploadedImageUrls[i],
            displayOrder: i,
            createdAt: DateTime.now(),
          );
          await _restaurantService.addRestaurantImage(restaurantImage);
        }
      }

      if (mounted) {
        _showSuccessSnackBar(
          widget.restaurant == null
              ? 'تم إضافة المطعم بنجاح'
              : 'تم تحديث المطعم بنجاح',
        );
        context.go(AppRoutes.adminDashboard);
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في حفظ المطعم: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.restaurant == null ? 'إضافة مطعم جديد' : 'تعديل المطعم',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.adminDashboard),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'المعلومات الأساسية',
                icon: Icons.info_outline,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'اسم المطعم',
                    hint: 'أدخل اسم المطعم',
                    icon: Icons.restaurant,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'وصف المطعم',
                    hint: 'أدخل وصف مختصر عن المطعم',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'معلومات الاتصال والموقع',
                icon: Icons.location_on,
                children: [
                  _buildTextField(
                    controller: _addressController,
                    label: 'العنوان',
                    hint: 'أدخل عنوان المطعم',
                    icon: Icons.location_on,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'رقم الهاتف',
                    hint: 'أدخل رقم الهاتف',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _latitudeController,
                          label: 'خط العرض',
                          hint: '36.7538',
                          icon: Icons.my_location,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _longitudeController,
                          label: 'خط الطول',
                          hint: '3.0588',
                          icon: Icons.location_searching,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'الصور',
                icon: Icons.photo_library,
                children: [
                  _buildCoverImageSection(),
                  const SizedBox(height: 20),
                  _buildAdditionalImagesSection(),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'الإعدادات',
                icon: Icons.settings,
                children: [
                  SwitchListTile(
                    title: const Text(
                      'المطعم نشط',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      _isActive ? 'المطعم مرئي للمستخدمين' : 'المطعم مخفي عن المستخدمين',
                      style: TextStyle(
                        color: _isActive ? Colors.green[600] : Colors.red[600],
                        fontSize: 12,
                      ),
                    ),
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                    activeColor: Colors.orange.shade600,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => context.go(AppRoutes.adminDashboard),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveRestaurant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
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
                    : Text(
                        widget.restaurant == null ? 'إضافة المطعم' : 'حفظ التغييرات',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.orange.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.orange.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildCoverImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الصورة الرئيسية',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickCoverImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
            ),
            child: _coverImageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_coverImageFile!.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : _coverImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _coverImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        ),
                      )
                    : _buildImagePlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalImagesSection() {
    final totalImages = _additionalImages.length + _additionalImageUrls.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'صور إضافية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            TextButton.icon(
              onPressed: _pickAdditionalImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('إضافة صور'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (totalImages > 0)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: totalImages,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: index < _additionalImages.length
                              ? Image.file(
                                  File(_additionalImages[index].path),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  _additionalImageUrls[index - _additionalImages.length],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeAdditionalImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 32,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 8),
                Text(
                  'اضغط لإضافة صور',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: 48,
          color: Colors.grey.shade500,
        ),
        const SizedBox(height: 12),
        Text(
          'اضغط لإضافة صورة',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'الحد الأقصى: 5 ميجابايت',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}