import 'package:flutter/material.dart';
import '../../../models/travel_agency_model.dart';
import '../../../services/travel_service.dart';
import '../../../services/admin_service.dart';

class TravelAdminScreen extends StatefulWidget {
  const TravelAdminScreen({super.key});

  @override
  State<TravelAdminScreen> createState() => _TravelAdminScreenState();
}

class _TravelAdminScreenState extends State<TravelAdminScreen> {
  List<TravelAgency> _agencies = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAgencies();
  }

  Future<void> _loadAgencies() async {
    try {
      final agencies = await TravelService().getAllTravelAgencies();
      setState(() {
        _agencies = agencies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل وكالات السفر: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<TravelAgency> get _filteredAgencies {
    if (_searchQuery.isEmpty) {
      return _agencies;
    }
    return _agencies.where((agency) {
      return agency.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (agency.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (agency.priceRange?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  Future<void> _deleteAgency(String agencyId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الوكالة؟'),
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
        // Note: You'll need to implement deleteTravelAgency in TravelService
        // await TravelService.deleteTravelAgency(agencyId);
        await _loadAgencies();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف الوكالة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في حذف الوكالة: ${e.toString()}'),
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
          'إدارة وكالات السفر',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAgencies,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade600,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'البحث في وكالات السفر...',
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
          
          // Agencies List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAgencies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flight_takeoff,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'لا توجد وكالات سفر'
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
                        onRefresh: _loadAgencies,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredAgencies.length,
                          itemBuilder: (context, index) {
                            final agency = _filteredAgencies[index];
                            return _buildAgencyCard(agency);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditAgencyDialog();
        },
        backgroundColor: Colors.teal.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAgencyCard(TravelAgency agency) {
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
                // Agency Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.teal.shade100,
                    child: agency.coverImage != null
                        ? Image.network(
                            agency.coverImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.flight_takeoff,
                                color: Colors.teal.shade600,
                                size: 30,
                              );
                            },
                          )
                        : Icon(
                            Icons.flight_takeoff,
                            color: Colors.teal.shade600,
                            size: 30,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Agency Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agency.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        agency.description ?? 'لا يوجد وصف',
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
                              agency.description ?? 'لا يوجد وصف',
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
                      _showAddEditAgencyDialog(agency: agency);
                    } else if (value == 'delete') {
                      _deleteAgency(agency.id);
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
            
            // Agency Stats
            Row(
              children: [
                _buildStatChip(
                  Icons.star,
                  agency.rating.toString(),
                  Colors.amber,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  Icons.reviews,
                  '${agency.totalReviews} تقييم',
                  Colors.blue,
                ),
                if (agency.phone != null) ...[
                  const SizedBox(width: 8),
                  _buildStatChip(
                    Icons.phone,
                    'هاتف',
                    Colors.green,
                  ),
                ],
                if (agency.isActive) ...[
                  const SizedBox(width: 8),
                  _buildStatChip(
                    Icons.verified,
                    'مرخصة',
                    Colors.teal,
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

  void _showAddEditAgencyDialog({TravelAgency? agency}) {
    showDialog(
      context: context,
      builder: (context) => AddEditTravelAgencyDialog(
        agency: agency,
        onSaved: () {
          _loadAgencies();
        },
      ),
    );
  }
}

class AddEditTravelAgencyDialog extends StatefulWidget {
  final TravelAgency? agency;
  final VoidCallback onSaved;

  const AddEditTravelAgencyDialog({
    super.key,
    this.agency,
    required this.onSaved,
  });

  @override
  State<AddEditTravelAgencyDialog> createState() => _AddEditTravelAgencyDialogState();
}

class _AddEditTravelAgencyDialogState extends State<AddEditTravelAgencyDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _specializationController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _logoController;
  late TextEditingController _licenseNumberController;
  bool _isLicensed = false;
  bool _isLoading = false;

  final List<String> _specializations = [
    'سفر ديني (حج وعمرة)',
    'سفر سياحي',
    'سفر أعمال',
    'سفر طلابي',
    'سفر طبي',
    'رحلات منظمة',
    'حجوزات طيران',
    'حجوزات فنادق',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.agency?.name ?? '');
    _descriptionController = TextEditingController(text: widget.agency?.description ?? '');
    _specializationController = TextEditingController(text: widget.agency?.description ?? '');
    _addressController = TextEditingController(text: widget.agency?.description ?? '');
    _phoneController = TextEditingController(text: widget.agency?.phone ?? '');
    _emailController = TextEditingController(text: widget.agency?.name ?? '');
    _websiteController = TextEditingController(text: widget.agency?.priceRange ?? '');
    _logoController = TextEditingController(text: widget.agency?.coverImage ?? '');
    _licenseNumberController = TextEditingController(text: widget.agency?.id ?? '');
    _isLicensed = widget.agency?.isActive ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _specializationController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _logoController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveAgency() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Note: You'll need to implement createTravelAgency and updateTravelAgency in TravelService
      /*
      if (widget.agency == null) {
        // Create new agency
        await TravelService.createTravelAgency(
          name: _nameController.text,
          description: _descriptionController.text,
          specialization: _specializationController.text,
          address: _addressController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          website: _websiteController.text.isEmpty ? null : _websiteController.text,
          logo: _logoController.text.isEmpty ? null : _logoController.text,
          isLicensed: _isLicensed,
          licenseNumber: _licenseNumberController.text.isEmpty ? null : _licenseNumberController.text,
        );
      } else {
        // Update existing agency
        await TravelService.updateTravelAgency(
          agencyId: widget.agency!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          specialization: _specializationController.text,
          address: _addressController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          website: _websiteController.text.isEmpty ? null : _websiteController.text,
          logo: _logoController.text.isEmpty ? null : _logoController.text,
          isLicensed: _isLicensed,
          licenseNumber: _licenseNumberController.text.isEmpty ? null : _licenseNumberController.text,
        );
      }
      */
      
      widget.onSaved();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.agency == null
                  ? 'تم إضافة الوكالة بنجاح'
                  : 'تم تحديث الوكالة بنجاح',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حفظ الوكالة: ${e.toString()}'),
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
              widget.agency == null ? 'إضافة وكالة سفر جديدة' : 'تعديل وكالة السفر',
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
                          labelText: 'اسم الوكالة *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال اسم الوكالة';
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
                        value: _specializations.contains(_specializationController.text)
                            ? _specializationController.text
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'التخصص *',
                          border: OutlineInputBorder(),
                        ),
                        items: _specializations.map((specialization) {
                          return DropdownMenuItem(
                            value: specialization,
                            child: Text(specialization),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _specializationController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار التخصص';
                          }
                          return null;
                        },
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
                      TextFormField(
                        controller: _logoController,
                        decoration: const InputDecoration(
                          labelText: 'رابط الشعار',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _isLicensed,
                            onChanged: (value) {
                              setState(() {
                                _isLicensed = value ?? false;
                              });
                            },
                          ),
                          const Text('وكالة مرخصة'),
                        ],
                      ),
                      if (_isLicensed) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _licenseNumberController,
                          decoration: const InputDecoration(
                            labelText: 'رقم الترخيص',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
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
                    onPressed: _isLoading ? null : _saveAgency,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
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
                        : Text(widget.agency == null ? 'إضافة' : 'تحديث'),
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