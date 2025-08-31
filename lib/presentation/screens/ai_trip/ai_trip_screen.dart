import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/ai_trip_request_model.dart';
import '../../../services/ai_trip_service.dart';

class AiTripScreen extends StatefulWidget {
  const AiTripScreen({super.key});

  @override
  State<AiTripScreen> createState() => _AiTripScreenState();
}

class _AiTripScreenState extends State<AiTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _daysController = TextEditingController();
  final _groupSizeController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  final _wilayaSearchController = TextEditingController();
  
  List<String> _selectedWilayas = [];
  List<String> _selectedPreferences = [];
  List<String> _selectedInterests = [];
  String _selectedTravelStyle = 'متوسط';
  String _wilayaSearchQuery = '';
  String _preferencesSearchQuery = '';
  String _interestsSearchQuery = '';
  
  AiTripResponse? _currentResponse;
  bool _isLoading = false;

  @override
  void dispose() {
    _budgetController.dispose();
    _daysController.dispose();
    _groupSizeController.dispose();
    _additionalInfoController.dispose();
    _wilayaSearchController.dispose();
    super.dispose();
  }

  Future<void> _generateTripPlan() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedWilayas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار ولاية واحدة على الأقل')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _currentResponse = AiTripResponse.loading();
    });

    final request = AiTripRequest(
      budget: double.parse(_budgetController.text),
      days: int.parse(_daysController.text),
      preferredWilayas: _selectedWilayas,
      preferences: _selectedPreferences,
      additionalInfo: _additionalInfoController.text.isEmpty 
          ? null 
          : _additionalInfoController.text,
      groupSize: int.parse(_groupSizeController.text),
      travelStyle: _selectedTravelStyle,
      interests: _selectedInterests,
    );

    try {
      final response = await AiTripService.generateTripPlan(request);
      setState(() {
        _currentResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentResponse = AiTripResponse.error('حدث خطأ: ${e.toString()}');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '🤖 مخطط الرحلات الذكي',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              _buildQuickPresets(),
              const SizedBox(height: 20),
              _buildBasicInfoSection(),
              const SizedBox(height: 20),
              _buildWilayasSection(),
              const SizedBox(height: 20),
              _buildPreferencesSection(),
              const SizedBox(height: 20),
              _buildInterestsSection(),
              const SizedBox(height: 20),
              _buildAdditionalInfoSection(),
              const SizedBox(height: 30),
              _buildGenerateButton(),
              const SizedBox(height: 20),
              if (_currentResponse != null) _buildResponseSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // النص على اليمين
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مخطط الرحلات الذكي',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                const Text(
                  'أخبرنا عن تفضيلاتك وسنخطط لك رحلة مثالية في الجزائر',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // الصورة على اليسار
          Expanded(
            flex: 1,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/ai.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPresets() {
    final presets = [
      {
        'title': 'رحلة صحراوية',
        'icon': '🏜️',
        'color': Colors.orange,
        'wilayas': ['تمنراست', 'أدرار', 'غرداية'],
        'preferences': ['الصحراء', 'المواقع التاريخية'],
        'interests': ['الطبيعة والمناظر', 'التصوير الفوتوغرافي', 'الثقافة المحلية'],
      },
      {
        'title': 'رحلة ساحلية',
        'icon': '🏖️',
        'color': Colors.blue,
        'wilayas': ['وهران', 'عنابة', 'جيجل', 'سكيكدة'],
        'preferences': ['البحر والشواطئ', 'المدن العصرية'],
        'interests': ['الاسترخاء والراحة', 'الأنشطة العائلية', 'الطعام المحلي'],
      },
      {
        'title': 'رحلة جبلية',
        'icon': '🏔️',
        'color': Colors.green,
        'wilayas': ['تيزي وزو', 'البويرة', 'باتنة'],
        'preferences': ['الجبال والطبيعة', 'الريف والقرى'],
        'interests': ['الطبيعة والمناظر', 'المغامرة والرياضة', 'التصوير الفوتوغرافي'],
      },
      {
        'title': 'رحلة تاريخية',
        'icon': '🏛️',
        'color': Colors.purple,
        'wilayas': ['قسنطينة', 'تلمسان', 'الجزائر'],
        'preferences': ['المواقع التاريخية', 'المواقع الأثرية', 'الثقافة والتراث'],
        'interests': ['التاريخ والآثار', 'الثقافة المحلية', 'المتاحف والفنون'],
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              '⚡ اختيارات سريعة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: presets.length,
              itemBuilder: (context, index) {
                final preset = presets[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedWilayas = List<String>.from(preset['wilayas'] as List);
                        _selectedPreferences = List<String>.from(preset['preferences'] as List);
                        _selectedInterests = List<String>.from(preset['interests'] as List);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم تطبيق إعدادات ${preset['title']}'),
                          backgroundColor: preset['color'] as Color,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (preset['color'] as Color).withOpacity(0.8),
                            (preset['color'] as Color).withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (preset['color'] as Color).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            preset['icon'] as String,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              preset['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: '📊 معلومات أساسية',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'الميزانية (دج)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الميزانية';
                    }
                    if (double.tryParse(value) == null) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _daysController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'عدد الأيام',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عدد الأيام';
                    }
                    final days = int.tryParse(value);
                    if (days == null || days < 1) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _groupSizeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'عدد الأشخاص',
                    prefixIcon: Icon(Icons.group),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عدد الأشخاص';
                    }
                    final size = int.tryParse(value);
                    if (size == null || size < 1) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedTravelStyle,
                  decoration: const InputDecoration(
                    labelText: 'نمط السفر',
                    prefixIcon: Icon(Icons.style),
                    border: OutlineInputBorder(),
                  ),
                  items: AiTripService.getTravelStyles()
                      .map((style) => DropdownMenuItem(
                            value: style,
                            child: Text(style),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTravelStyle = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWilayasSection() {
    final regions = AiTripService.getAlgerianWilayasByRegion();
    
    return _buildSection(
      title: '🗺️ الولايات المفضلة',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط البحث
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: _wilayaSearchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن ولاية...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                setState(() {
                  _wilayaSearchQuery = value;
                });
              },
            ),
          ),
          // أزرار التحديد السريع
          if (_wilayaSearchQuery.isEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedWilayas.clear();
                        _selectedWilayas.addAll(regions.values
                            .expand((wilayas) => wilayas)
                            .toList());
                      });
                    },
                    icon: const Icon(Icons.select_all, size: 18),
                    label: const Text('تحديد الكل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedWilayas.clear();
                      });
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('إلغاء الكل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          // المناطق الجغرافية
          ...regions.entries.map((entry) => _buildRegionCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildRegionCard(String regionName, List<String> wilayas) {
    final regionColors = {
      'الشمال': Colors.blue,
      'الوسط': Colors.green,
      'الغرب': Colors.orange,
      'الشرق': Colors.purple,
      'الجنوب': Colors.teal,
      'الصحراء الكبرى': Colors.amber,
    };
    
    final regionIcons = {
      'الشمال': Icons.waves,
      'الوسط': Icons.landscape,
      'الغرب': Icons.wb_sunny,
      'الشرق': Icons.wb_sunny,
      'الجنوب': Icons.terrain,
      'الصحراء الكبرى': Icons.wb_sunny_outlined,
    };
    
    final color = regionColors[regionName] ?? Colors.grey;
    final icon = regionIcons[regionName] ?? Icons.location_on;
    
    // تصفية الولايات بناءً على البحث
    final filteredWilayas = _wilayaSearchQuery.isEmpty
        ? wilayas
        : wilayas.where((wilaya) => 
            wilaya.toLowerCase().contains(_wilayaSearchQuery.toLowerCase())).toList();
    
    if (filteredWilayas.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(
          regionName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
        subtitle: _wilayaSearchQuery.isNotEmpty 
            ? Text('${filteredWilayas.length} نتيجة', style: const TextStyle(fontSize: 12))
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filteredWilayas.map((wilaya) => FilterChip(
                label: Text(
                  wilaya,
                  style: const TextStyle(fontSize: 12),
                ),
                selected: _selectedWilayas.contains(wilaya),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedWilayas.add(wilaya);
                    } else {
                      _selectedWilayas.remove(wilaya);
                    }
                  });
                },
                selectedColor: color.withOpacity(0.3),
                checkmarkColor: color,
                backgroundColor: Colors.white,
                side: BorderSide(color: color.withOpacity(0.5)),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    final preferences = AiTripService.getTravelPreferencesWithIcons();
    
    // Filter preferences based on search query
    final filteredPreferences = _preferencesSearchQuery.isEmpty
        ? preferences
        : Map.fromEntries(preferences.entries.where((entry) => 
            entry.key.toLowerCase().contains(_preferencesSearchQuery.toLowerCase())));
    
    return _buildSection(
      title: '🎯 التفضيلات السياحية',
      child: Column(
        children: [
          // Search bar for preferences
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث في التفضيلات...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                setState(() {
                  _preferencesSearchQuery = value;
                });
              },
            ),
          ),
          // Quick selection buttons
          if (_preferencesSearchQuery.isEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedPreferences.clear();
                        _selectedPreferences.addAll(preferences.keys.toList());
                      });
                    },
                    icon: const Icon(Icons.select_all, size: 18),
                    label: const Text('تحديد الكل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedPreferences.clear();
                      });
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('إلغاء الكل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          // Grid view for preferences
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: filteredPreferences.length,
            itemBuilder: (context, index) {
              final entry = filteredPreferences.entries.elementAt(index);
              final preference = entry.key;
              final icon = entry.value;
              final isSelected = _selectedPreferences.contains(preference);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedPreferences.remove(preference);
                    } else {
                      _selectedPreferences.add(preference);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [Colors.blue.shade400, Colors.blue.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        preference,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    final interests = AiTripService.getTravelInterestsWithIcons();
    
    // Filter interests based on search query
    final filteredInterests = _interestsSearchQuery.isEmpty
        ? interests
        : Map.fromEntries(interests.entries.where((entry) => 
            entry.key.toLowerCase().contains(_interestsSearchQuery.toLowerCase())));
    
    return _buildSection(
      title: '💡 الاهتمامات',
      child: Column(
        children: [
          // Search bar for interests
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث في الاهتمامات...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                setState(() {
                  _interestsSearchQuery = value;
                });
              },
            ),
          ),
          // Quick selection buttons
          if (_interestsSearchQuery.isEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedInterests.clear();
                        _selectedInterests.addAll(interests.keys.toList());
                      });
                    },
                    icon: const Icon(Icons.select_all, size: 18),
                    label: const Text('تحديد الكل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedInterests.clear();
                      });
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('إلغاء الكل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          // Grid view for interests
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: filteredInterests.length,
            itemBuilder: (context, index) {
              final entry = filteredInterests.entries.elementAt(index);
              final interest = entry.key;
              final icon = entry.value;
              final isSelected = _selectedInterests.contains(interest);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedInterests.remove(interest);
                    } else {
                      _selectedInterests.add(interest);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [Colors.orange.shade400, Colors.orange.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          interest,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return _buildSection(
      title: '📝 معلومات إضافية',
      child: TextFormField(
        controller: _additionalInfoController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'أي معلومات أو طلبات خاصة تريد إضافتها...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _generateTripPlan,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'جاري التخطيط...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                '🚀 خطط رحلتي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildResponseSection() {
    return _buildSection(
      title: '✨ خطة رحلتك',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _currentResponse!.isLoading
            ? const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('جاري إنشاء خطة رحلتك...'),
                ],
              )
            : _currentResponse!.error != null
                ? Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentResponse!.error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : SelectableText(
                    _currentResponse!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}